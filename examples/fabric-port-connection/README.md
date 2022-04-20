# Fabric Port Connection Example

This example demonstrates usage of the Equinix Connection OCI module to establish a non-redundant
Equinix Fabric L2 Connection from a Equinix Fabric port to OCI FastConnect. It will:

- Create OCI Compartment. Note that in this example it is created using the resource but it can
also be created using the module. However, here we create an Oracle virtual cloud network (VCN)
to demonstrate the usage of field 'oci_drg_vcn_attachments' and for that reason we create a new
compartment previously to have both VCN and FastConnect resources within same compartment.
- Create OCI Dynamic Routing Gateway (DRG).
- Create OCI FastConnect private Virtual Circuit.
- Create Equinix Fabric l2 connection with minimun available bandwidth (default behavior if
'fabric_speed' is not specified) for 'Oracle Cloud Infrastructure -OCI- FastConnect' service
profile.
- Attach the VCN to the DRG.

## Usage

To provision this example, you should clone the github repository and run terraform from within this
directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-oci.git
cd terraform-equinix-fabric-connection-oci/examples/fabric-port-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/fabric-port-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-oci/equinix/latest/examples/fabric-port-connection?tab=outputs> for a description of all outputs.
