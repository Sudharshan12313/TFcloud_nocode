# Resource Group per VM
resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-${var.environment}-${var.vm_name}-rg"
  location = var.location
}

# Virtual Network unique per VM
resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# Subnet for VM
resource "azurerm_subnet" "this" {
  name                 = "${var.prefix}-${var.environment}-${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

# Optional NSG (will be attached to NIC in vm module)
resource "azurerm_network_security_group" "this" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# NSG rules: SSH for Linux, RDP for Windows (source restricted to VNet)
resource "azurerm_network_security_rule" "ssh_in" {
  count = var.create_nsg && lower(var.os_type) == "linux" ? 1 : 0

  name                        = "Allow-SSH-In-VNet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = azurerm_virtual_network.this.address_space[0]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_network_security_rule" "rdp_in" {
  count = var.create_nsg && lower(var.os_type) == "windows" ? 1 : 0

  name                        = "Allow-RDP-In-VNet"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = azurerm_virtual_network.this.address_space[0]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_network_security_rule" "out_http_https" {
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

