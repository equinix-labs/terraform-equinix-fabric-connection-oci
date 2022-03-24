locals {
  oci_fc_provider_id = [
    for sp in data.oci_core_fast_connect_provider_services.this.fast_connect_provider_services : sp.id
    if sp.provider_name == "Equinix"
  ][0]

  oci_gateway_name = coalesce(var.oci_gateway_name, format("rg-%s", random_string.this.result))
  oci_gateway_id   = var.oci_create_gateway ? oci_core_drg.this[0].id : [
    for gateway in data.oci_core_drgs.this[0].drgs : gateway.id
    if gateway.display_name == local.oci_gateway_name
  ][0]

  oci_compartment_name = coalesce(var.oci_compartment_name, format("compartment-fc-%s", random_string.this.result))
  oci_compartment_id   = var.oci_create_compartment ? oci_identity_compartment.this[0].id : var.oci_compartment_id

  oci_bgp_config = oci_core_virtual_circuit.this.cross_connect_mappings[0]
}

resource "oci_identity_compartment" "this" {
  count = var.oci_create_compartment ? 1 : 0

  compartment_id = coalesce(var.oci_parent_compartment_id, var.oci_tenancy_id)
  name           = local.oci_compartment_name
  description    = var.oci_compartment_description

  freeform_tags = var.oci_freeform_tags
  defined_tags  = var.oci_defined_tags
}

data "oci_core_fast_connect_provider_services" "this" {
  compartment_id = var.oci_tenancy_id
}

data "oci_core_drgs" "this" {
  count = var.oci_create_gateway ? 0 : 1

  compartment_id = local.oci_compartment_id
}

resource "oci_core_drg" "this" {
  count = var.oci_create_gateway ? 1 : 0

  display_name = local.oci_gateway_name
  compartment_id = local.oci_compartment_id

  freeform_tags = var.oci_freeform_tags
  defined_tags  = var.oci_defined_tags
}

resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

resource "oci_core_virtual_circuit" "this" {
  type                 = "PRIVATE"
  compartment_id       = local.oci_compartment_id
  display_name         = coalesce(var.oci_fc_vc_name, lower(format("vc-%s", random_string.this.result)))
  bandwidth_shape_name = format("%d Gbps", var.fabric_speed)

  cross_connect_mappings {
    customer_bgp_peering_ip = var.oci_fc_vc_customer_bgp_peering_ip
    oracle_bgp_peering_ip   = var.oci_fc_vc_oracle_bgp_peering_ip
    bgp_md5auth_key         = var.oci_fc_vc_bgp_auth_key
  }

  customer_asn        = var.oci_fc_vc_bgp_customer_asn
  gateway_id          = local.oci_gateway_id
  provider_service_id = local.oci_fc_provider_id
  region              = var.oci_region

  freeform_tags = var.oci_freeform_tags
  defined_tags  = var.oci_defined_tags
}

module "equinix-fabric-connection" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name                      = var.fabric_connection_name
  seller_profile_name       = "Oracle Cloud Infrastructure -OCI- FastConnect"
  seller_metro_code         = var.fabric_destination_metro_code
  seller_metro_name         = var.fabric_destination_metro_name
  seller_region             = var.oci_region
  seller_authorization_key  = oci_core_virtual_circuit.this.id
  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = "GB"
  purcharse_order_number    = var.fabric_purcharse_order_number
}

resource "equinix_network_bgp" "this" {
  count = alltrue([var.network_edge_device_id != "", var.network_edge_configure_bgp]) ? 1 : 0

  connection_id      = module.equinix-fabric-connection.primary_connection.uuid
  local_ip_address   = local.oci_bgp_config.customer_bgp_peering_ip
  local_asn          = tonumber(local.oci_bgp_config.customer_asn)
  remote_ip_address  = split("/", local.oci_bgp_config.oracle_bgp_peering_ip)[0]
  remote_asn         = tonumber(local.oci_bgp_config.oracle_bgp_asn)
  authentication_key = local.oci_bgp_config.bgp_md5auth_key
}
