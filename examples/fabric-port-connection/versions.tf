terraform {  
  required_version = ">= 0.13"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.5.0"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 4.66.0"
    }
  }
}
