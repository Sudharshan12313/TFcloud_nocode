output "vm_ids" {
  value = module.vm.vm_ids
}

output "private_ips" {
  value = module.vm.private_ips
}

output "public_ips" {
  value = module.network.public_ip_ids
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "resource_group_name" {
  value = module.network.resource_group_name
}
