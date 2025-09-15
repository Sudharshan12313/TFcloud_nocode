# NIC Creation
resource "azurerm_network_interface" "this" {
  count               = var.vm_count
  name                = "${var.prefix}-${var.environment}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }
}

# NIC -> NSG Association
resource "azurerm_network_interface_security_group_association" "this" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.this[count.index].id
  network_security_group_id = var.nsg_id
}

# ----------------------
# Linux VM (Ubuntu)
# ----------------------
resource "azurerm_linux_virtual_machine" "this" {
  count                 = var.os_type == "linux" ? var.vm_count : 0
  name                  = "${var.prefix}-${var.environment}-vm-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [element(azurerm_network_interface.this.*.id, count.index)]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# ----------------------
# Windows 11 Enterprise (Single-session AVD)
# ----------------------
resource "azurerm_windows_virtual_machine" "this" {
  count                 = var.os_type == "windows" ? var.vm_count : 0
  name                  = "${var.prefix}-${var.environment}-vm-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [element(azurerm_network_interface.this.*.id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # ✅ Windows 11 Enterprise *single-session* (AVD supported)
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-ent"
    version   = "latest"
  }
}

# ----------------------
# Outputs
# ----------------------
output "vm_ids" {
  value = concat(
    [for vm in azurerm_linux_virtual_machine.this : vm.id],
    [for vm in azurerm_windows_virtual_machine.this : vm.id]
  )
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.this : nic.ip_configuration[0].private_ip_address]
}
