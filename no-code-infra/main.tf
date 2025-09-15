terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# -------------------------
# Network Module
# -------------------------
module "network" {
  source      = "../modules/network"
  prefix      = var.prefix
  environment = var.environment
  location    = var.location

  vnet_address_space = var.vnet_address_space
  subnets            = var.subnets
  create_nsg         = var.create_nsg
  nsgs               = var.nsgs
  create_public_ip   = var.create_public_ip
  public_ip_count    = var.public_ip_count
}

# -------------------------
# VM Module
# -------------------------
module "vm" {
  source      = "../modules/vm"
  prefix      = var.prefix
  environment = var.environment
  location    = var.location

  resource_group_name = module.network.resource_group_name
  subnet_id           = module.network.subnet_ids[var.vm_subnet_name]
  public_ip_id        = try(module.network.public_ip_ids[0], null)

  # ✅ NEW: Attach NSG directly to NIC
  nsg_id = module.network.nsg_ids[var.vm_nsg_name]

  vm_count             = var.vm_count
  vm_size              = var.vm_size
  os_type              = var.os_type
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  admin_ssh_public_key = file(var.admin_ssh_public_key)
}
