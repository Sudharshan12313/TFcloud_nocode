prefix = "demo"
environment = "dev"

vm_configs = {
  linux_vm = {
    vm_name        = "linux-vm"
    location       = "East US"
    vnet_cidr      = "10.10.0.0/16"
    subnet_cidr    = "10.10.1.0/24"
    create_nsg     = true
    vm_size        = "Standard_B1s"
    os_type        = "linux"
    admin_username = "azureadmin"
    # placeholder public key (replace with your real public key or use file(...) in real runs)
    ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPLACEHOLDER your-key@domain"
  }

  windows_vm = {
    vm_name        = "windows-vm"
    location       = "West Europe"
    vnet_cidr      = "10.20.0.0/16"
    subnet_cidr    = "10.20.1.0/24"
    create_nsg     = true
    vm_size        = "Standard_B2s"
    os_type        = "windows"
    admin_username = "azureadmin"
    # placeholder password (replace with secure password meeting Azure complexity)
    admin_password = "P@ssw0rd12345!"
  }
}
