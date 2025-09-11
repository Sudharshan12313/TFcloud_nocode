variable "prefix" { type = string }
variable "environment" { type = string }
variable "location" { type = string }

variable "vnet_address_space" {
  type = list(string)
  default = ["10.10.0.0/16"]
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    { name = "app", address_prefix = "10.10.1.0/24" }
  ]
}

variable "create_nsg"       { type = bool default = true }
variable "nsgs"             { type = list(any) default = [] }
variable "create_public_ip" { type = bool default = false }
variable "public_ip_count"  { type = number default = 0 }

variable "vm_count"   { type = number default = 1 }
variable "vm_size"    { type = string default = "Standard_DS1_v2" }
variable "os_type"    { type = string default = "linux" }

variable "vm_subnet_name" { type = string default = "app" }

variable "admin_username"       { type = string default = "azureuser" }
variable "admin_password"       { type = string default = "" }
variable "admin_ssh_public_key" { type = string default = "" }
