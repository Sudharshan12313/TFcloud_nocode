# Network module: create RG, VNet, Subnet, optional NSG (NSG isn't assigned here; returned for vm to attach to NIC)
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.environment}-${var.resource_group_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "${var.prefix}-${var.environment}-${var.resource_group_name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.prefix}-${var.environment}-${var.resource_group_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "inbound_ssh" {
  count = var.create_nsg && lower(var.os_type) == "linux" ? 1 : 0

  name                        = "Allow-SSH-In-VNet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.vnet_cidr
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_network_security_rule" "inbound_rdp" {
  count = var.create_nsg && lower(var.os_type) == "windows" ? 1 : 0

  name                        = "Allow-RDP-In-VNet"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.vnet_cidr
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_network_security_rule" "outbound_http_https" {
  count = var.create_nsg ? 1 : 0

  name                        = "Allow-Out-HTTP-HTTPS"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80-443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}

output "nsg_id" {
  value = var.create_nsg ? azurerm_network_security_group.this[0].id : null
}
