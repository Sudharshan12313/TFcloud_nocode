output "vm_id" {
  value = coalesce(
    try(azurerm_linux_virtual_machine.this[0].id, null),
    try(azurerm_windows_virtual_machine.this[0].id, null)
  )
}

output "private_ip" {
  value = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}

output "nsg_id" {
  value = var.nsg_id
}

output "resource_group_name" {
  value = var.resource_group_name
}
