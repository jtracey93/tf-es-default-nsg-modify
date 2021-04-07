variable "azureRegions" {
  type        = set(string)
  description = "A set of Azure Regions that you wish the default NSG to be deployed into. Please use region short names e.g. 'uksouth', 'northeurope'."
}

variable "defaultRegion" {
  type        = string
  description = "Default Azure Region to deploy Resoruce Group into (if not specified will use North Europe)"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to be used for the resoruces created by this module."
  default = {
    GitHub-Repo = "https://github.com/jtracey93/tf-es-default-nsg-modify"
    IaC         = "Terraform"
  }
}

variable "namePrefix" {
  type        = string
  description = "A prefix that will be used for namin all resources created by this module."
  default     = "default"

  validation {
    condition     = length(var.namePrefix) <= 7 && can(regex("[[:alnum:]]", var.namePrefix))
    error_message = "Name Prefix cannot exceed 7 characters and must only contain alphanumeric characters."
  }
}

variable "nsgRules" {
  type        = list(map(string))
  description = "A list of maps detailing the default NSG rules."
  default = [
    {
      name                       = "module-def-in-block-vnet-all"
      direction                  = "Inbound"
      access                     = "Deny"
      priority                   = "4050"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      source_port_range          = "*"
      destination_port_range     = "*"
    },
    {
      name                       = "module-def-out-block-vnet-all"
      direction                  = "Outbound"
      access                     = "Deny"
      priority                   = "4050"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      source_port_range          = "*"
      destination_port_range     = "*"
    }
  ]
}
