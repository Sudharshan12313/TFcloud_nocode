# Project settings
prefix      = "demo"
environment = "dev"
location    = "eastus"

# Networking
vnet_address_space = ["10.10.0.0/16"]

subnets = [
  { name = "app", address_prefix = "10.10.1.0/24" }
]

create_nsg = true

nsgs = [
  {
    name = "default"
    rules = [
      {
        name                       = "Allow-RDP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
]

create_public_ip = false
public_ip_count  = 0

# VM
vm_count     = 1
vm_size      = "Standard_B2s"   # ✅ free-tier eligible size
os_type      = "linux"        # change to "linux" for Ubuntu
vm_subnet_name = "app"
vm_nsg_name    = "default"

# Login
admin_username = "azureuser"
admin_password = "Password123!"   # required for Windows VM
# admin_ssh_public_key = "ssh-rsa AAAA...yourkey"   # required if Linux
admin_ssh_public_key = "~/.ssh/id_rsa.pub"