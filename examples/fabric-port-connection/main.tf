provider "equinix" {}

provider "oci" {}

variable "tenancy_ocid" {}

variable "port_name" {}

module "equinix-fabric-connection-oci" {
  # source  = "equinix-labs/fabric-connection-oci/equinix"
  source  = "../../"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  oci_tenancy_id            = var.tenancy_ocid

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}

output "connection_details" {
  value = module.equinix-fabric-connection-oci
}
