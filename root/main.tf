terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# For each VM config, create network resources and VM using modules
module "network" {
  for_each = var.vm_configs
  source   = "./modules/network"

  prefix     = var.prefix
  environment = var.environment
  vm_name    = each.value.vm_name
  location   = each.value.location
  vnet_cidr  = each.value.vnet_cidr
  subnet_cidr = each.value.subnet_cidr
  create_nsg = each.value.create_nsg
  os_type    = each.value.os_type
}

module "vm" {
  for_each = var.vm_configs
  source   = "./modules/vm"

  prefix              = var.prefix
  environment         = var.environment
  vm_name             = each.value.vm_name
  location            = each.value.location
  vm_size             = each.value.vm_size
  os_type             = lower(each.value.os_type)
  admin_username      = each.value.admin_username
  admin_password      = lookup(each.value, "admin_password", null)
  ssh_public_key      = lookup(each.value, "ssh_public_key", null)

  # Network outputs from network module
  resource_group_name = module.network[each.key].resource_group_name
  subnet_id           = module.network[each.key].subnet_id
  nsg_id              = module.network[each.key].nsg_id
}
