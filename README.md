# Azure Default NSG In Specified Regions Module (tf-es-default-nsg-modify)

This Terraform module, for Azure, will build a default NSG (that you can define) in all regions that you specify. This can then be used with a modify policy, like [this one](https://github.com/Azure/Community-Policy/tree/master/Policies/Network/modify-subnet-nsg) to enable you to satisfy a requirement that all subnets have an NSG applied as part of your [Enterprise Scale](https://aka.ms/enterprisescale/overview) deployment.

## Example Usage

```hcl

module "defaultNSG" {
  source = "github.com/jtracey93/tf-es-default-nsg-modify?ref=v0.1"

  defaultRegion = "westeurope" # OPTIONAL - Defaults to "northeurope" if not specified. This is where the Resource Group containing all the NSGs is created.

  namePrefix   = "acme"
  azureRegions = [
    "northeurope",
    "westeurope"
  ] # REQUIRED - A set of strings defining the Azure regions you wish to deploy these default NSGs too. Please use the cli names for the regions e.g. 'northeurope' or 'uksouth' etc.

  nsgRules = [
    {
      name                       = "demo-allow-https-in-vnet"
      direction                  = "Inbound"
      access                     = "Allow"
      priority                   = "4000"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      source_port_range          = "*"
      destination_port_range     = "443"
    },
    {
      name                       = "demo-allow-https-out-vnet"
      direction                  = "Outbound"
      access                     = "Allow"
      priority                   = "4000"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      source_port_range          = "*"
      destination_port_range     = "443"
    }
  ] # OPTIONAL - This is an optional block, if you do not specify this 2 NSG rules are create to DENY all inbound & outbound traffic from the service tag 'VirtualNetwork' to the service tag 'VirtualNetwork'.

  tags = {
    key1 = "value1"
    key2 = "value2"
  } # OPTIONAL - This is an optional map for tags to add to the Resoruce Group and NSGs created by this module. Default Tags will be applied if none specified (detailed below).

  # OPTIONAL - The below is only required if you need to deploy into multiple subscriptions via Terraform provider aliases
  # providers = {
  #   azurerm = azurerm.aliasName # REPLACE the alias name with the alias you wish to deploy this module too.
  # }

}

```

## Argument Reference

The following arguments are supported:

* `source` - (Required) Specifies the path to the module.

* `defaultRegion` - (Optional) The name of the Azure Region to target where the Resource Group will be deployed. Defaults to `northeurope`.

* `namePrefix` - (Optional) The name prefix to use in naming the Resource Group and NSGs that will be created by this module. Defaults to 'default'. Can only be 7 alphanumeric characters in length max.

* `azureRegions` - (Required) A set of strings that define which Azure Regions to create NSGs in. Please use the cli names for the regions e.g. `northeurope` or `uksouth` etc. You can find these with Azure CLI using the command `az account list-locations --output table`

* `nsgRules` - (Optional) A list of maps that define your NSG rules. These must be as if you were defining a nested NSG rule (`security_rule`) as part of a normal NSG creation in Terraform as per the [docs here.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)

* `tags` - (Optional) A map of tags to be applied to the resources created by this module. If none specified 2 tags will be applied as per below

```hcl

{
  GitHub-Repo = "https://github.com/jtracey93/tf-es-default-nsg-modify"
  IaC         = "Terraform"
}

```

## Attributes Reference

The following attributes are exported:

* `nsgsOutput` - The output of the entire NSG as an object/map per region
* `rsgOutput` - The output of the entire RSG as an object/map.
