variable "prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnets" {
  description = "List of subnets with optional NSG attachment"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_name       = optional(string) # NEW: optional NSG name for automatic association
  }))
}

variable "create_nsg" {
  type    = bool
  default = true
}

variable "nsgs" {
  description = "List of NSGs with rules"
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

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "public_ip_count" {
  type    = number
  default = 0
}
