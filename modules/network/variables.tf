variable "prefix" { type = string }
variable "environment" { type = string }
variable "location" { type = string }

variable "vnet_address_space" {
  type = list(string)
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "create_nsg" { type = bool default = true }
variable "nsgs" {
  type = list(object({
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
  default = []
}

variable "create_public_ip" { type = bool default = false }
variable "public_ip_count"  { type = number default = 0 }
