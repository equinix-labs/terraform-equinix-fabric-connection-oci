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

variable "tenancy_ocid" {
  type = string
  description = "(Required) The OCID of your tenancy."
}

variable "metal_project_id" {
  type        = string
  description = "(Required) ID of the project where the connection is scoped to, used to look up the project."
}

variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."
  default = ["example@equinix.com"]
}

variable "fabric_destination_metro_code" {
  type        = string
  description = "Destination Metro code where the connection will be created."
  default     = "SV"
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If unspecified, it will be used the minimum
  bandwidth available for the `Equinix Metal` service profile. Valid values are
  (50, 100, 200, 500, 1000, 2000, 5000, 10000).
  EOF
  default     = 50
}

variable "oci_region" {
  type        = string
  description = <<EOF
  The OCI region where resources will be created. Check the list of OCI regions
  [here](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions).
  EOF
  default = "us-sanjose-1"
}

variable "oci_core_drg_attachment_next_hop_id" {
  type = string
  description = <<EOF
  (Optional) The OCID of the next hop DRG attachment. The next hop DRG attachment is responsible for reaching
  the network destination. Ignore this variable if you don't want to route traffic between two DRGs.
  EOF
  default = ""
}
