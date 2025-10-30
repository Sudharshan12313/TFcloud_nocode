prefix = "demo"
environment = "dev"

mode = "foreach"

admin_username = "azureadmin"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...yourkey..."

linux_vms = [
  {
    name                = "linux-vm-1"
    vm_size             = "Standard_B1s"
    resource_group_name = "rg-linux-1"
    location            = "East US"
    vnet_cidr           = "10.10.0.0/16"
    subnet_cidr         = "10.10.1.0/24"
    create_nsg          = true
  },
  {
    name                = "linux-vm-2"
    vm_size             = "Standard_B1s"
    resource_group_name = "rg-linux-2"
    location            = "East US"
    vnet_cidr           = "10.20.0.0/16"
    subnet_cidr         = "10.20.1.0/24"
    create_nsg          = false
  }
]

windows_vms = [
  {
    name                = "win-vm-1"
    vm_size             = "Standard_B2s"
    resource_group_name = "rg-win-1"
    location            = "West Europe"
    vnet_cidr           = "10.30.0.0/16"
    subnet_cidr         = "10.30.1.0/24"
    create_nsg          = true
    admin_password      = "Complex@1234"
  }
]
