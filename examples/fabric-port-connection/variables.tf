variable "port_name" {
  type        = string
  description = <<EOF
  Name of the [Equinix Fabric port](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/ports/Fabric-port-details.htm)
  from which the connection would originate.
  EOF
}

variable "tenancy_ocid" {
  type = string
  description = "The OCID of your tenancy."
}
