resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = "${var.prefix}-${var.environment}-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_nsg ? length(var.nsgs) : 0
  name                = "${var.prefix}-${var.environment}-nsg-${var.nsgs[count.index].name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  security_rule       = var.nsgs[count.index].rules
}

resource "azurerm_public_ip" "this" {
  count               = var.create_public_ip ? var.public_ip_count : 0
  name                = "${var.prefix}-${var.environment}-pip-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_ids" {
  value = { for i, nsg in azurerm_network_security_group.this : var.nsgs[i].name => nsg.id }
}

output "public_ip_ids" {
  value = [for pip in azurerm_public_ip.this : pip.id]
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}
