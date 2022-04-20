# Network Edge Device Connection Example

This example demonstrates usage of the Equinix Connection OCI module to establish a non-redundant
Equinix Fabric L2 Connection from a Equinix Network Edge device to OCI FastConnect. It will:

- Create OCI Dynamic Routing Gateway (DRG).
- Create OCI FastConnect private Virtual Circuit.
- Create Equinix Fabric l2 connection with 2 Gbps bandwidth.
- Configure BGP session from OCI private Virtual Circuit to your Network Edge device.

In addition, in this example we demonstrate how you can add a routing rule to the default DRG table route
for VCNs.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-oci.git
cd terraform-equinix-fabric-connection-oci/examples/network-edge-device-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/network-edge-device-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/network-edge-device-connection?tab=outputs> for a description of all outputs.
