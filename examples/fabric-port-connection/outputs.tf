output "connection_details" {
  value = module.equinix-fabric-connection-oci
}

output "oci_compartment_id" {
  value = oci_identity_compartment.this.id
}

output "oci_vcn_id" {
  value = oci_core_vcn.this.id
}
