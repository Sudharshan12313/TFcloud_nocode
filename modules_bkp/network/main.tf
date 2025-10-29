# ----------------------
# Resource Group
# ----------------------
resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
}

# ----------------------
# Virtual Network
# ----------------------
resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
}

# ----------------------
# Subnets
# ----------------------
resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = "${var.prefix}-${var.environment}-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

# ----------------------
# NSG Creation with dynamic rules
# ----------------------
resource "azurerm_network_security_group" "this" {
  for_each            = { for nsg in var.nsgs : nsg.name => nsg }
  name                = "${var.prefix}-${var.environment}-nsg-${each.value.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# ----------------------
# Public IPs (Optional)
# ----------------------
resource "azurerm_public_ip" "this" {
  count               = var.create_public_ip ? var.public_ip_count : 0
  name                = "${var.prefix}-${var.environment}-pip-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}