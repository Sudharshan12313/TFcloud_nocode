output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}

output "nsg_id" {
  value = var.create_nsg ? azurerm_network_security_group.this[0].id : null
}
