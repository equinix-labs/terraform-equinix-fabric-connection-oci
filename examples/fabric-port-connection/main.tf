provider "equinix" {}

provider "oci" {}

resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = "example-compartment"
  description    = "Example compartment Equinix fabric connection OCI terraform module"

  freeform_tags = {"terraform"= "true"}
}

resource "oci_core_vcn" "this" {
  compartment_id = oci_identity_compartment.this.id

  cidr_blocks = ["10.0.0.0/16"]
  display_name = "example-vcn-1"

  freeform_tags = {"terraform"= "true"}
}

module "equinix-fabric-connection-oci" {
  source = "equinix-labs/fabric-connection-oci/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  oci_tenancy_id            = var.tenancy_ocid

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"

  oci_create_compartment = false
  oci_compartment_id     = oci_identity_compartment.this.id

  oci_drg_vcn_attachments = {
    "example-vcn-1" = {
      "vcn_id" = oci_core_vcn.this.id // (Required) The OCID of the network to attach to the DRG.
      "vcn_route_type" = "" // (Optional) Indicates whether the VCN CIDR(s) or the individual Subnet CIDR(s) are imported from the attachment. One of: 'SUBNET_CIDRS', 'VCN_CIDRS'.
      "vcn_transit_routing_rt_id" = "" // (Optional) VCN Route table - Use this advanced feature only if you're setting up transit routing.
      "drg_route_table_id" = "" // (Optional) DRG route table - If not specified, it will use the autogenerated DRG Route Table for VCN attachemts. You would associate a DRG route table if you want to set up transit routing through a VCN.
    }
  }
}

