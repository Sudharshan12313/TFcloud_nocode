variable "prefix" {
  type        = string
  description = "Prefix for all resources (e.g., project name)"
}

variable "environment" {
  type        = string
  description = "Environment (e.g., dev, sit, prod)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Virtual network address space"
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "List of subnets"
}

variable "create_nsg" {
  type        = bool
  description = "Whether to create NSGs"
}

variable "nsgs" {
  type        = list(object({
    name  = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  description = "List of NSGs with rules"
}

variable "create_public_ip" {
  type        = bool
  description = "Whether to create public IPs"
}

variable "public_ip_count" {
  type        = number
  description = "Number of public IPs to create"
}

# -------------------------
# VM Variables (all required)
# -------------------------
variable "vm_count" {
  type        = number
  description = "Number of VMs to create"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM"
}

variable "os_type" {
  type        = string
  description = "Choose VM OS type: linux or windows"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "vm_subnet_name" {
  type        = string
  description = "Subnet where VM NICs will be created"
}

variable "vm_nsg_name" {
  type        = string
  description = "NSG to attach to VM NICs"
}

variable "admin_username" {
  type        = string
  description = "Admin username for VM login"
}

# OS-Specific Inputs
variable "admin_password" {
  type        = string
  description = "Windows VM password (required if os_type = windows)"
  nullable    = true

  validation {
    condition     = var.os_type != "windows" || (var.admin_password != null && length(var.admin_password) > 0)
    error_message = "You must provide admin_password if os_type is windows."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "Linux VM SSH public key path (required if os_type = linux)"
  nullable    = true

  validation {
    condition     = var.os_type != "linux" || (var.ssh_public_key != null && length(var.ssh_public_key) > 0)
    error_message = "You must provide ssh_public_key if os_type is linux."
  }
}


