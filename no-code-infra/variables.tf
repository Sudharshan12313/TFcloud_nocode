variable "prefix" {
  type        = string
  description = "Prefix for all resources (e.g. project name)"
}

variable "environment" {
  type        = string
  description = "Environment (e.g. dev, sit, prod)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.10.0.0/16"]
  description = "Virtual network address space"
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    { name = "app", address_prefix = "10.10.1.0/24" }
  ]
  description = "List of subnets"
}

variable "create_nsg" {
  type    = bool
  default = true
}

variable "nsgs" {
  type    = list(any)
  default = []
}

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "public_ip_count" {
  type    = number
  default = 0
}

# -------------------------
# VM Variables
# -------------------------
variable "vm_count" {
  type    = number
  default = 1
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "os_type" {
  type        = string
  default     = "linux"
  description = "Choose VM OS type: linux or windows"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "vm_subnet_name" {
  description = "Subnet where VM NICs will be created"
  type        = string
  default     = "app"
}

variable "vm_nsg_name" {
  description = "NSG to attach to VM NICs"
  type        = string
  default     = "" # leave empty if no NSG association required
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin username for VM login"
}

variable "admin_password" {
  type        = string
  default     = null
  nullable    = true
  description = "Windows VM password (required if os_type = windows)"

  validation {
    condition     = var.os_type != "windows" || (var.admin_password != null && length(var.admin_password) > 0)
    error_message = "You must provide admin_password if os_type is windows."
  }
}

variable "admin_ssh_public_key" {
  type        = string
  default     = null
  nullable    = true
  description = "Linux VM SSH public key path (required if os_type = linux)"

  validation {
    condition     = var.os_type != "linux" || (var.admin_ssh_public_key != null && length(var.admin_ssh_public_key) > 0)
    error_message = "You must provide admin_ssh_public_key if os_type is linux."
  }
}
