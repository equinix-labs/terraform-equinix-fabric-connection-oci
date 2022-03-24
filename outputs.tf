output "fabric_connection_uuid" {
  description = "Unique identifier of the connection."
  value       = module.equinix-fabric-connection.primary_connection.uuid
}

output "fabric_connection_name" {
  description = "Name of the connection."
  value       = module.equinix-fabric-connection.primary_connection.name
}

output "fabric_connection_status" {
  description = "Connection provisioning status."
  value       = module.equinix-fabric-connection.primary_connection.status
}

output "fabric_connection_provider_status" {
  description = "Connection provisioning provider status."
  value       = module.equinix-fabric-connection.primary_connection.provider_status
}

output "fabric_connection_speed" {
  description = "Connection speed."
  value       = module.equinix-fabric-connection.primary_connection.speed
}

output "fabric_connection_speed_unit" {
  description = "Connection speed unit."
  value       = module.equinix-fabric-connection.primary_connection.speed_unit
}

output "fabric_connection_seller_metro" {
  description = "Connection seller metro code."
  value       = module.equinix-fabric-connection.primary_connection.seller_metro_code
}

output "fabric_connection_seller_region" {
  description = "Connection seller region."
  value       = module.equinix-fabric-connection.primary_connection.seller_region
}

output "network_edge_bgp_state" {
  description = "Network Edge device BGP peer state."
  value       = try(equinix_network_bgp.this[0].state, "")
}

output "network_edge_bgp_provisioning_status" {
  description = "Network Edge device BGP peering configuration provisioning status."
  value       = try(equinix_network_bgp.this[0].provisioning_status, "")
}

output "oci_compartment_name" {
  description = "Compartment name."
  value = local.oci_compartment_name
}

output "oci_compartment_id" {
  description = "Compartment ID."
  value = local.oci_compartment_id
}

output "oci_fastconnect_virtual_circuit_id" {
  description = "FastConnect virtual circuit - ID."
  value = oci_core_virtual_circuit.this.id
}

output "oci_fastconnect_virtual_circuit_state" {
  description = <<EOF
  FastConnect virtual circuit - The virtual circuit's current state. For information about the different states, see
  FastConnect [Overview](https://docs.cloud.oracle.com/iaas/Content/Network/Concepts/fastconnect.htm)
  EOF
  value = oci_core_virtual_circuit.this.state
}

output "oci_fastconnect_virtual_circuit_service_type" {
  description = "FastConnect virtual circuit - Provider service type."
  value = oci_core_virtual_circuit.this.service_type
}

output "oci_fastconnect_virtual_circuit_bgp_session_state" {
  description = "FastConnect virtual circuit - The state of the Ipv4 BGP session associated with the virtual circuit."
  value = oci_core_virtual_circuit.this.bgp_session_state
}

output "oci_fastconnect_virtual_circuit_provider_state" {
  description = <<EOF
  FastConnect virtual circuit - The Equinix's state in relation to this virtual circuit.
  One of 'ACTIVE', 'INACTIVE'.
  EOF
  value = oci_core_virtual_circuit.this.provider_state
}
