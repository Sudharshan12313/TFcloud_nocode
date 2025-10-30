output "vm_id" { value = coalesce(try(azurerm_linux_virtual_machine.linux[0].id, null), try(azurerm_windows_virtual_machine.windows[0].id, null)) }
output "private_ip" { value = azurerm_network_interface.this.ip_configuration[0].private_ip_address }
output "resource_group_name" { value = module.network.resource_group_name }
output "nsg_id" { value = module.network.nsg_id }
