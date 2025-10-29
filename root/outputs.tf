output "vm_private_ips" {
  value = { for k, m in module.vm : k => try(m.private_ip, null) }
}

output "vm_ids" {
  value = { for k, m in module.vm : k => try(m.vm_id, null) }
}

output "nsg_ids" {
  value = { for k, m in module.network : k => try(m.nsg_id, null) }
}

output "rg_names" {
  value = { for k, m in module.network : k => try(m.resource_group_name, null) }
}
