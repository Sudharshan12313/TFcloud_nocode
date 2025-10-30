variable "prefix" {
  type    = string
  default = "demo"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "mode" {
  description = "Deployment mode: 'count' or 'foreach'"
  type        = string
  default     = "foreach"
}

# COUNT mode inputs
variable "linux_vm_count" {
  description = "Number of Linux VMs to create in count mode"
  type        = number
  default     = 0
}

variable "linux_vm_size" {
  description = "Size of the Linux VMs for count mode"
  type        = string
  default     = "Standard_B1s"
}

variable "common_resource_group_name" {
  description = "Common resource group name used in count mode"
  type        = string
  default     = "rg-common"
}

variable "common_location" {
  description = "Common location used in count mode"
  type        = string
  default     = "East US"
}

variable "common_vnet_cidr" {
  description = "Common VNet CIDR used in count mode"
  type        = string
  default     = "10.100.0.0/16"
}

variable "common_subnet_cidr" {
  description = "Common Subnet CIDR used in count mode"
  type        = string
  default     = "10.100.1.0/24"
}

variable "common_create_nsg" {
  description = "Whether to create NSG in count mode"
  type        = bool
  default     = true
}

# credentials & admin
variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for Linux VMs"
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "Admin password for Windows VMs (used for foreach windows)"
  type        = string
  default     = ""
}

# FOREACH mode lists
variable "linux_vms" {
  description = "List of Linux VM configurations for foreach mode"
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
  description = "List of Windows VM configurations for foreach mode"
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
