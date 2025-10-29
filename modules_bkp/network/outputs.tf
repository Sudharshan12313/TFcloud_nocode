# ----------------------
# Outputs
# ----------------------
output "subnet_ids" {
  value = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_ids" {
  value = { for k, v in azurerm_network_security_group.this : k => v.id }
}

output "public_ip_ids" {
  value = [for pip in azurerm_public_ip.this : pip.id]
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}