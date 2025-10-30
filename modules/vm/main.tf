# VM module: calls network module to create RG, VNet, Subnet, NSG (optional), then creates NIC + VM (no public IP)

module "network" {
  source = "../network"

  prefix              = var.prefix
  environment         = var.environment
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  subnet_cidr         = var.subnet_cidr
  create_nsg          = var.create_nsg
  os_type             = var.os_type
}

# Network Interface (no public IP)
resource "azurerm_network_interface" "this" {
  name                = "${var.prefix}-${var.environment}-${var.vm_name}-nic"
  location            = var.location
  resource_group_name = module.network.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Attach NSG to NIC if created
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count = var.create_nsg ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = module.network.nsg_id
}

# Linux VM
resource "azurerm_linux_virtual_machine" "linux" {
  count                 = var.os_type == "linux" ? 1 : 0
  name                  = "${var.prefix}-${var.environment}-${var.vm_name}"
  location              = var.location
  resource_group_name   = module.network.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.this.id]

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

# Windows VM
resource "azurerm_windows_virtual_machine" "windows" {
  count                 = var.os_type == "windows" ? 1 : 0
  name                  = "${var.prefix}-${var.environment}-${var.vm_name}"
  location              = var.location
  resource_group_name   = module.network.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

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

output "vm_id" {
  value = coalesce(try(azurerm_linux_virtual_machine.linux[0].id, null), try(azurerm_windows_virtual_machine.windows[0].id, null))
}

output "private_ip" {
  value = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}

output "resource_group_name" {
  value = module.network.resource_group_name
}
