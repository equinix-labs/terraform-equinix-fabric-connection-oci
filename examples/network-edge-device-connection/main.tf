# Configure the Equinix Provider
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
}

# Configure the OCI Provider
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {}

module "equinix-fabric-connection-oci" {
  source = "equinix-labs/fabric-connection-oci/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  oci_tenancy_id            = var.tenancy_ocid

  # optional variables
  network_edge_device_id     = var.device_id
  network_edge_configure_bgp = true

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 2
}

resource "oci_core_drg_route_table_route_rule" "test_drg_route_table_route_rule" {
  count = var.oci_core_drg_attachment_next_hop_id != "" ? 1 : 0

  drg_route_table_id         = module.equinix-fabric-connection-oci.oci_drg_autogenerated_vcn_route_table_id
  destination                = "192.168.1.0/24" // This is the range of IP addresses used for matching when routing traffic.
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = var.oci_core_drg_attachment_next_hop_id
}
