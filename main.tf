# Declare o provedor Azure
provider "azurerm" {
  features {}
}

# Crie o grupo de recursos
resource "azurerm_resource_group" "vmwordpress" {
  name     = "vmwordpress_group"
  location = "East US" # Substitua pela sua região desejada
}

# Crie uma máquina virtual com uma imagem do Ubuntu
resource "azurerm_linux_virtual_machine" "wordpress_vm" {
  name                = "wordpress-vm"
  location            = azurerm_resource_group.vmwordpress.location
  resource_group_name = azurerm_resource_group.vmwordpress.name

  size                = "Standard_DS2_v2"
  admin_username      = "desafiodata@outlook.com" # Substitua pelo nome de usuário desejado
  admin_password      = "74553125Ca@" # Substitua pela sua senha

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.wordpress_vm.id]
}

# Crie uma interface de rede para a máquina virtual
resource "azurerm_network_interface" "wordpress_vm" {
  name                = "wordpress-nic"
  location            = azurerm_resource_group.vmwordpress.location
  resource_group_name = azurerm_resource_group.vmwordpress.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Crie uma subnet para a rede da máquina virtual (substitua pelos valores corretos)
resource "azurerm_subnet" "example" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.vmwordpress.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Crie uma rede virtual (substitua pelos valores corretos)
resource "azurerm_virtual_network" "example" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vmwordpress.location
  resource_group_name = azurerm_resource_group.vmwordpress.name
}
