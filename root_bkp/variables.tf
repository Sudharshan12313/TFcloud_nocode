variable "prefix" { type = string, default = "demo" }
variable "environment" { type = string, default = "dev" }

variable "mode" {
  description = "Deployment mode: 'count' or 'foreach'"
  type        = string
  default     = "foreach"
}

# COUNT mode inputs
variable "linux_vm_count" { type = number, default = 0 }
variable "linux_vm_size" { type = string, default = "Standard_B1s" }
variable "common_resource_group_name" { type = string, default = "rg-common" }
variable "common_location" { type = string, default = "East US" }
variable "common_vnet_cidr" { type = string, default = "10.100.0.0/16" }
variable "common_subnet_cidr" { type = string, default = "10.100.1.0/24" }
variable "common_create_nsg" { type = bool, default = true }

# credentials & admin
variable "admin_username" { type = string, default = "azureadmin" }
variable "ssh_public_key" { type = string, default = "" }
variable "admin_password" { type = string, default = "" }

# FOREACH mode lists
variable "linux_vms" {
  type = list(object({
    name                = string
    vm_size             = string
    resource_group_name = string
    location            = string
    vnet_cidr           = string
    subnet_cidr         = string
    create_nsg          = bool
  }))
  default = []
}

variable "windows_vms" {
  type = list(object({
    name                = string
    vm_size             = string
    resource_group_name = string
    location            = string
    vnet_cidr           = string
    subnet_cidr         = string
    create_nsg          = bool
    admin_password      = string
  }))
  default = []
}
