terraform {
  required_version = ">= 0.13"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 4.66.0"
    }
  }
  provider_meta "equinix" {
    module_name = "equinix-fabric-connection-oci"
  }
}
