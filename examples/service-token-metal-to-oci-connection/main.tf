# Configure the Equinix Provider
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
}

# Configure the OCI Provider
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  region = var.oci_region
}

## Retrieve an existing equinix metal project
## If you prefer you can use resource equinix_metal_project instead to create a fresh project
data "equinix_metal_project" "this" {
  project_id = var.metal_project_id
}

locals {
  connection_name = format("conn-metal-oci-%s", lower(var.fabric_destination_metro_code))
}

# Create a new VLAN in Frankfurt
resource "equinix_metal_vlan" "this" {
  description = format("VLAN in %s", var.fabric_destination_metro_code)
  metro       = var.fabric_destination_metro_code
  project_id  = data.equinix_metal_project.this.project_id
}

## Request a connection service token in Equinix Metal
resource "equinix_metal_connection" "this" {
    name               = local.connection_name
    project_id         = data.equinix_metal_project.this.project_id
    metro              = var.fabric_destination_metro_code
    redundancy         = "primary"
    type               = "shared"
    service_token_type = "a_side"
    description        = format("connection to OCI in %s", var.fabric_destination_metro_code)
    speed              = format("%dMbps", var.fabric_speed)
    vlans              = [equinix_metal_vlan.this.vxlan]
}

resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = "example-compartment"
  description    = "Example compartment Equinix fabric connection OCI terraform module"

  freeform_tags = {"terraform"= "true"}
}

resource "oci_core_vcn" "this" {
  compartment_id = oci_identity_compartment.this.id

  cidr_blocks  = ["10.0.0.0/16"]
  display_name = "example-vcn-1"

  freeform_tags = {"terraform"= "true"}
}

module "equinix-fabric-connection-oci" {
  source = "equinix-labs/fabric-connection-oci/equinix"

  ## required variables
  fabric_notification_users = ["example@equinix.com"]
  oci_tenancy_id            = var.tenancy_ocid

  ## optional variables
  fabric_destination_metro_code = "FR"
  fabric_speed                  = 2
  fabric_service_token_id       = equinix_metal_connection.this.service_tokens.0.id


  ## configure BGP
  # oci_fc_vc_customer_bgp_peering_ip = "10.0.0.18/31" // If unspecified, default value "10.0.0.18/31" will be used
  # oci_fc_vc_oracle_bgp_peering_ip   = "10.0.0.19/31" // If unspecified, default value "10.0.0.18/31" will be used
  oci_fc_vc_bgp_auth_key            = random_password.this.result
  # oci_fc_vc_bgp_customer_asn        = "65000"// If unspecified, default value "65000" will be used

  oci_region              = var.oci_region
  oci_create_compartment  = false // we create compartment out of the module to use the same one for oci_core_vcn.this
  oci_compartment_id      = oci_identity_compartment.this.id
  oci_drg_vcn_attachments = {
    "example-vcn-1" = {
      "vcn_id"                    = oci_core_vcn.this.id // (Required) The OCID of the network to attach to the DRG.
      "vcn_route_type"            = "" // (Optional) Indicates whether the VCN CIDR(s) or the individual Subnet CIDR(s) are imported from the attachment. One of: 'SUBNET_CIDRS', 'VCN_CIDRS'.
      "vcn_transit_routing_rt_id" = "" // (Optional) VCN Route table - Use this advanced feature only if you're setting up transit routing.
      "drg_route_table_id"        = "" // (Optional) DRG route table - If not specified, it will use the autogenerated DRG Route Table for VCN attachemts. You would associate a DRG route table if you want to set up transit routing through a VCN.
    }
  }
}

resource "oci_core_drg_route_table_route_rule" "test_drg_route_table_route_rule" {
  count = var.oci_core_drg_attachment_next_hop_id != "" ? 1 : 0

  drg_route_table_id         = module.equinix-fabric-connection-oci.oci_drg_autogenerated_vcn_route_table_id
  destination                = "192.168.1.0/24" // This is the range of IP addresses used for matching when routing traffic.
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = var.oci_core_drg_attachment_next_hop_id
}

## Optionally we use an auto-generated password to enable authentication (shared key) between the two BGP peers
resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "$%&*()-_=+[]{}<>:?"
}
