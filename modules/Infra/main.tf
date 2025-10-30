resource "azurerm_resource_group" "infra" {
  name     = "${var.prefix}-${var.environment}-${var.resource_group_name}"
  location = var.location
}

resource "azurerm_virtual_network" "infra" {
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.infra.name
}

resource "azurerm_subnet" "infra" {
  name                 = "${var.prefix}-${var.environment}-${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "infra" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.infra.name
}

resource "azurerm_network_security_rule" "ssh" {
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
  resource_group_name         = azurerm_resource_group.infra.name
  network_security_group_name = azurerm_network_security_group.infra[0].name
}

resource "azurerm_network_security_rule" "rdp" {
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
  resource_group_name         = azurerm_resource_group.infra.name
  network_security_group_name = azurerm_network_security_group.infra[0].name
}

resource "azurerm_network_security_rule" "outbound_http_https" {
  count = var.create_nsg ? 1 : 0

  name                        = "Allow-Outbound-HTTP-HTTPS"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80-443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.infra.name
  network_security_group_name = azurerm_network_security_group.infra[0].name
}

resource "azurerm_network_interface" "infra" {
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.infra.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "infra" {
  count = var.create_nsg ? 1 : 0

  network_interface_id      = azurerm_network_interface.infra.id
  network_security_group_id = azurerm_network_security_group.infra[0].id
}

resource "azurerm_linux_virtual_machine" "linux" {
  count                 = var.os_type == "linux" ? 1 : 0
  name                  = "${var.prefix}-${var.environment}-${var.vm_name}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.infra.name
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.infra.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "windows" {
  count                 = var.os_type == "windows" ? 1 : 0
  name                  = "${var.prefix}-${var.environment}-${var.vm_name}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.infra.name
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.infra.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
