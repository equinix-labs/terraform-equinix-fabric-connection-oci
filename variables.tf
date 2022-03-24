variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."

  validation {
    condition     = length(var.fabric_notification_users) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "fabric_connection_name" {
  type        = string
  description = "Name of the connection resource that will be created. It will be auto-generated if not specified."
  default     = ""
}

variable "fabric_destination_metro_code" {
  type        = string
  description = <<EOF
  Destination Metro code where the connection will be created. If you do not know the code,
  'fabric_destination_metro_name' can be use instead.
  EOF
  default     = ""

  validation {
    condition = (
      var.fabric_destination_metro_code == "" ? true : can(regex("^[A-Z]{2}$", var.fabric_destination_metro_code))
    )
    error_message = "Valid metro code consits of two capital leters, i.e. 'FR', 'SV', 'DC'."
  }
}

variable "fabric_destination_metro_name" {
  type        = string
  description = <<EOF
  Only required in the absence of 'fabric_destination_metro_code'. Metro name where the connection will be created,
  i.e. 'Frankfurt', 'Silicon Valley', 'Ashburn'. One of 'fabric_destination_metro_code', 'fabric_destination_metro_name'
  must be provided.
  EOF
  default     = ""
}

variable "network_edge_device_id" {
  type        = string
  description = "Unique identifier of the Network Edge virtual device from which the connection would originate."
  default     = ""
}

variable "network_edge_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id', identifier of network interface on a given device, used for a connection.
  If not specified then first available interface will be selected.
  EOF
  default     = 0
}

variable "network_edge_configure_bgp" {
  type        = bool
  description = <<EOF
  Creation and management of Equinix Network Edge BGP peering configurations. Applicable with
  'network_edge_device_id'.
  EOF
  default     = false
}
variable "fabric_port_name" {
  type        = string
  description = <<EOF
  Name of the buyer's port from which the connection would originate. One of 'fabric_port_name',
  'network_edge_device_id' or 'fabric_service_token_id' is required.
  EOF
  default     = ""
}

variable "fabric_vlan_stag" {
  type        = number
  description = <<EOF
  S-Tag/Outer-Tag of the primary connection - a numeric character ranging from 2 - 4094. Required if 'port_name' is
  specified.
  EOF
  default     = 0
}

variable "fabric_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the connection would originate.
  EOF
  default     = ""
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Gbps to be allocated to the connection. If not specified, it will be used the minimum bandwidth
  available for the OCI service profile.
  EOF
  default     = 1

  validation {
    condition     = contains([1, 2, 3, 4, 5, 10], var.fabric_speed)
    error_message = "Valid values are (1, 2, 3, 4, 5, 10)."
  }
}

variable "fabric_purcharse_order_number" {
  type        = string
  description = "Connection's purchase order number to reflect on the invoice."
  default     = ""
}

variable "oci_tenancy_id" {
  type        = string
  description = "The OCID of your tenancy (the root compartment)."
}

variable "oci_create_compartment" {
  type        = bool
  description = "Create a compartment where to create all resources."
  default     = true
}

variable "oci_compartment_id" {
  description = "Compartment's OCID where to create all resources. Required if 'oci_create_compartment' is false."
  type        = string
  default     = ""
}

variable "oci_compartment_name" {
  type        = string
  description = <<EOF
  Compartment's name in which to create the resources. If unspecified, it will be auto-generated. Applicable if
  'oci_create_compartment' is true.
  EOF
  default     = ""
}

variable "oci_compartment_description" {
  type        = string
  description = <<EOF
  Description of the compartment in which to create the resources. Applicable if 'oci_create_compartment'
  is true.
  EOF
  default     = "Compartment containing a Fast Connect Partner Link via Equinix Fabric."
}

variable "oci_parent_compartment_id" {
  type        = string
  description = <<EOF
  OCID of the parent compartment containing the new compartment. If unspecified, the root compartment 'oci_tenancy_id'
  will be used. Applicable if 'oci_create_compartment' is true.
  EOF
  default     = ""
}

variable "oci_create_gateway" {
  type        = bool
  description = "Create a Dynamic Routing Gateway that the virtual circuit will use."
  default     = true
}

variable "oci_gateway_name" {
  type        = string
  description = <<EOF
  The name for Dynamic Routing Gateway. If unspecified, it will be auto-generated. Required if
  'oci_create_gateway' is false."
  EOF
  default     = ""
}

variable "oci_region" {
  type        = string
  description = <<EOF
  The OCI region where resources will be created. Check the list of OCI regions
  [here](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions).
  EOF
  default = ""
}

variable "oci_freeform_tags" {
  type        = map(any)
  description = <<EOF
  Simple key-value pairs to tag the created resources using OCI
  [Free-form tags](https://docs.oracle.com/en-us/iaas/Content/Tagging/Concepts/understandingfreeformtags.htm#Understanding_Freeform_Tags).
  EOF
  default = {
    Terraform = "true"
    Module    = "equinix-labs/fabric-connection-oci/equinix"
  }
}

variable "oci_defined_tags" {
  type        = map(string)
  description = <<EOF
  Predefined and scoped to a namespace to tag the resources created using OCI
  [Defined-tags](https://docs.oracle.com/en-us/iaas/Content/Tagging/Tasks/managingtagsandtagnamespaces.htm#Managing_Tags_and_Tag_Namespaces).
  EOF
  default     = {}
}

variable "oci_fc_vc_name" {
  type        = string
  description = "The name of the Fast Connect private Virtual Circuit. If unspecified, it will be auto-generated."
  default = ""
}

variable "oci_fc_vc_customer_bgp_peering_ip" {
  type        = string
  description = "The BGP IPv4 address for the router on the Equinix end of the BGP session."
  default     = "10.0.0.18/31"
}

variable "oci_fc_vc_oracle_bgp_peering_ip" {
  type        = string
  description = "The BGP IPv4 address for Oracle's end of the BGP session."
  default     = "10.0.0.19/31"
}

variable "oci_fc_vc_bgp_customer_asn" {
  type        = string
  description = <<EOF
  The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration on the Equinix end
  of the BGP session.
  EOF
  default     = "65000"
}

variable "oci_fc_vc_bgp_auth_key" {
  type        = string
  description = "The key for BGP MD5 authentication. Only applicable if your system requires MD5 authentication."
  default     = ""
}
