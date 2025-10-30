output "linux_count_vm_ids" {
  value = local.use_count ? module.linux_count[*].vm_id : []
}

output "linux_foreach_vm_ids" {
  value = local.use_foreach ? { for k, m in module.linux_vms : k => m.vm_id } : {}
}

output "windows_foreach_vm_ids" {
  value = local.use_foreach ? { for k, m in module.windows_vms : k => m.vm_id } : {}
}

output "all_private_ips" {
  value = merge(
    local.use_count ? { for i, m in module.linux_count : i => try(m.private_ip, null) } : {},
    local.use_foreach ? { for k, m in module.linux_vms : k => try(m.private_ip, null) } : {},
    local.use_foreach ? { for k, m in module.windows_vms : k => try(m.private_ip, null) } : {}
  )
}
