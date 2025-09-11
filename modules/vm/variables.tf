variable "prefix" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "public_ip_id" { type = string default = null }

variable "vm_count" { type = number default = 1 }
variable "vm_size" { type = string default = "Standard_DS1_v2" }
variable "os_type" { type = string default = "linux" }

variable "admin_username" { type = string }
variable "admin_password" { type = string default = "" }
variable "admin_ssh_public_key" { type = string default = "" }
