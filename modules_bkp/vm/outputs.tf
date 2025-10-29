# ----------------------
# Outputs
# ----------------------
output "vm_ids" {
  value = concat(
    [for vm in azurerm_linux_virtual_machine.this : vm.id],
    [for vm in azurerm_windows_virtual_machine.this : vm.id]
  )
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.this : nic.ip_configuration[0].private_ip_address]
}