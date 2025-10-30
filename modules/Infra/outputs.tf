output "vm_id" {
  value = coalesce(
    try(azurerm_linux_virtual_machine.linux[0].id, null),
    try(azurerm_windows_virtual_machine.windows[0].id, null)
  )
}

output "private_ip" {
  value = azurerm_network_interface.infra.ip_configuration[0].private_ip_address
}

output "resource_group_name" {
  value = azurerm_resource_group.infra.name
}

output "vnet_id" {
  value = azurerm_virtual_network.infra.id
}

output "subnet_id" {
  value = azurerm_subnet.infra.id
}

output "nsg_id" {
  value = var.create_nsg ? azurerm_network_security_group.infra[0].id : null
}
