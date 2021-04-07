terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.43.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  defaultRegion   = (var.defaultRegion != null ? var.defaultRegion : "northeurope")
}

resource "azurerm_resource_group" "rsg" {
  name     = "${var.namePrefix}-rsg-policy-nsg"
  location = local.defaultRegion
  tags     = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.azureRegions

  location            = each.key
  resource_group_name = azurerm_resource_group.rsg.name
  name                = "${var.namePrefix}-nsg-${each.key}"
  tags                = var.tags

  dynamic "security_rule" {

    for_each = var.nsgRules
    iterator = nsg
    content {
      name                       = nsg.value.name
      direction                  = nsg.value.direction
      access                     = nsg.value.access
      priority                   = nsg.value.priority
      protocol                   = nsg.value.protocol
      source_address_prefix      = nsg.value.source_address_prefix
      destination_address_prefix = nsg.value.destination_address_prefix
      source_port_range          = nsg.value.source_port_range
      destination_port_range     = nsg.value.destination_port_range
    }

  }
}
