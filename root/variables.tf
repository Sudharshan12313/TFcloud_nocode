variable "prefix" {
  type    = string
  default = "demo"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vm_configs" {
  description = "Map of VM configurations keyed by identifier"
  type = map(object({
    vm_name        = string
    location       = string
    vnet_cidr      = string
    subnet_cidr    = string
    create_nsg     = bool
    vm_size        = string
    os_type        = string
    admin_username = string
    admin_password = optional(string)
    ssh_public_key = optional(string)
  }))
}
