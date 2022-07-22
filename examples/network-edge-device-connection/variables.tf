variable "equinix_provider_client_id" {
  type        = string
  description = <<EOF
  API Consumer Key available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTID shell environment variable.
  EOF
  default     = null
}

variable "equinix_provider_client_secret" {
  type        = string
  description = <<EOF
  API Consumer secret available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTSECRET shell environment variable.
  EOF
  default     = null
}

variable "device_id" {
  type = string
  description = <<EOF
  (Required) The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}

variable "tenancy_ocid" {
  type = string
  description = "(Required) The OCID of your tenancy."
}

variable "oci_core_drg_attachment_next_hop_id" {
  type = string
  description = <<EOF
  (Optional) The OCID of the next hop DRG attachment. The next hop DRG attachment is responsible for reaching
  the network destination. Ignore this variable if you don't want to route traffic between two DRGs.
  EOF
  default = ""
}
