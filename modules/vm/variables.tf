variable "prefix" { type = string }
variable "environment" { type = string }
variable "vm_name" { type = string }
variable "location" { type = string }
variable "vm_size" { type = string }
variable "os_type" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string, default = null }
variable "ssh_public_key" { type = string, default = null }

# Values passed from network module (outputs)
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "nsg_id" { type = string, default = null }
