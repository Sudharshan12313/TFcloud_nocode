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

locals {
  use_count   = var.mode == "count"
  use_foreach = var.mode == "foreach"
}

# COUNT MODE: create N identical Linux VMs in one RG/location (simple)
module "linux_count" {
  source = "./modules/vm"
  count  = local.use_count ? var.linux_vm_count : 0

  prefix              = var.prefix
  environment         = var.environment
  vm_name             = "${var.prefix}-linux-${count.index}"
  os_type             = "linux"
  vm_size             = var.linux_vm_size
  resource_group_name = var.common_resource_group_name
  location            = var.common_location
  vnet_cidr           = var.common_vnet_cidr
  subnet_cidr         = var.common_subnet_cidr
  create_nsg          = var.common_create_nsg
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

# FOREACH MODE: fully flexible per-VM config lists
module "linux_vms" {
  for_each = local.use_foreach ? { for vm in var.linux_vms : vm.name => vm } : {}
  source   = "./modules/vm"

  prefix              = var.prefix
  environment         = var.environment
  vm_name             = each.value.name
  os_type             = "linux"
  vm_size             = each.value.vm_size
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  vnet_cidr           = each.value.vnet_cidr
  subnet_cidr         = each.value.subnet_cidr
  create_nsg          = each.value.create_nsg
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

module "windows_vms" {
  for_each = local.use_foreach ? { for vm in var.windows_vms : vm.name => vm } : {}
  source   = "./modules/vm"

  prefix              = var.prefix
  environment         = var.environment
  vm_name             = each.value.name
  os_type             = "windows"
  vm_size             = each.value.vm_size
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  vnet_cidr           = each.value.vnet_cidr
  subnet_cidr         = each.value.subnet_cidr
  create_nsg          = each.value.create_nsg
  admin_username      = var.admin_username
  admin_password      = each.value.admin_password
}
