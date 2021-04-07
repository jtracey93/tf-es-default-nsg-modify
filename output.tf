output "rsgOutput" {
  value = azurerm_resource_group.rsg  
}

output "nsgsOutput" {
  value = azurerm_network_security_group.nsg
}