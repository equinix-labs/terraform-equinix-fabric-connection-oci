# Fabric Port Connection Example

This example demonstrates usage of the Equinix Connection module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to OCI FastConnect. It will:

- Create OCI Compartment
- Create OCI Dynamic Routing Gateway (DRG)
- Create OCI FastConnect private Virtual Circuit
- Create Equinix Fabric l2 connection with minimun available bandwidth for 'Oracle Cloud Infrastructure -OCI- FastConnect' service profile

## Usage

```bash
terraform init
terraform apply
```
