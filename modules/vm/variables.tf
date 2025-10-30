variable "prefix" { type = string }
variable "environment" { type = string }
variable "vm_name" { type = string }
variable "os_type" { type = string }
variable "vm_size" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_cidr" { type = string }
variable "subnet_cidr" { type = string }
variable "create_nsg" { type = bool }
variable "admin_username" { type = string }
variable "admin_password" { type = string, default = null }
variable "ssh_public_key" { type = string, default = null }
