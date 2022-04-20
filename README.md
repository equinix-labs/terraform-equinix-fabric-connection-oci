## Equinix Fabric L2 Connection To Oracle Cloud Infrastructure FastConnect Terraform module

[![Experimental](https://img.shields.io/badge/Stability-Experimental-red.svg)](https://github.com/equinix-labs/standards#about-uniform-standards)
[![terraform](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml)

`terraform-equinix-fabric-connection-oci` is a Terraform module that utilizes [Terraform provider for Equinix](https://registry.terraform.io/providers/equinix/equinix/latest) and [Terraform provider for OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) to set up an Equinix Fabric L2 connection to OCI Fast Connect.

As part of Platform Equinix, your infrastructure can connect with other parties, such as public cloud providers, network service providers, or your own colocation cages in Equinix by defining an [Equinix Fabric - software-defined interconnection](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/Fabric-landing-main.htm).

This module creates a Dynamic Routing Gateway (DRG) or uses an existing one, a private Virtual Circuit in OCI, and the l2 connection in Equinix Fabric using the Virtual Circuit OCID as
authentication key. BGP in Equinix side can be optionally configured if Network Edge device is used. Optionally you can attach multiple VCNs to the DRG.

```html
     Origin                                              Destination
    (A-side)                                              (Z-side)

┌────────────────┐
│ Equinix Fabric │         Equinix Fabric          ┌────────────────────┐       ┌──────────────────────────┐
│ Port / Network ├─────    l2 connection   ───────►│        OCI         │──────►│     Private VC ─► DRG    │
│ Edge Device /  │         (1 - 10 Gbps)           │    FastConnect     │       │    ─► DRG/VCNs attach    │
│ Service Token  │                                 └────────────────────┘       │       (OCI Region)       │
└────────────────┘                                                              └──────────────────────────┘
         │                                                                           │
         └ - - - - - - - - - - Network Edge Device - - - - - - - - - - - - - - - - - ┘
                                   BGP peering
```

### Usage

This project is experimental and supported by the user community. Equinix does not provide support for this project.

Install Terraform using the official guides at <https://learn.hashicorp.com/tutorials/terraform/install-cli>.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as:

```hcl
# main.tf
provider "equinix" {}

provider "oci" {}

variable "tenancy_ocid" {}
variable "device_id" {}

module "equinix-fabric-connection-oci" {
  source  = "equinix-labs/fabric-connection-oci/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  oci_tenancy_id            = var.tenancy_ocid

  # optional variables
  network_edge_device_id     = var.device_id
  network_edge_configure_bgp = true

  fabric_destination_metro_code = "FR" //Frankfurt
  fabric_speed                  = 2 //Speed in Gbps
}
```

Run `terraform init -upgrade` and `terraform apply`.

#### Resources

| Name | Type |
| :-----: | :------: |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [equinix-fabric-connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection/equinix/latest) | module |
| [equinix_network_bgp.this](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/equinix_network_bgp) | resource |
| [oci_identity_compartment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |
| [oci_identity_compartment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_core_virtual_circuit.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_virtual_circuit) | resource |
| [oci_core_drg.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg) | resource |
| [oci_core_drg_attachment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_drg_attachment) | resource |
| [oci_core_drgs.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_drgs) | data source |
| [oci_core_fast_connect_provider_services.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_fast_connect_provider_services) | data source |
| [oci_core_drg_route_tables.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_drg_route_tables) | data source |

#### Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest?tab=inputs> for a description of all variables.

#### Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest?tab=outputs> for a description of all outputs.

### Examples

- [Fabric Port connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/fabric-port-connection/)
- [Network Edge device connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/network-edge-device-connection/)
