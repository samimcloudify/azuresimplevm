
resource "azurerm_resource_group" "main" {
  name     = "RG3"
  location = "Southeast Asia"
}

resource "azurerm_virtual_network" "main" {
  name                = "VNET2"
  address_space       = ["10.0.0.0/22"]
  location            = "Southeast Asia"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main123" {
  name                = "vm-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

}


resource "azurerm_linux_virtual_machine" "main" {
  name                            = "linux-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = "Southeast Asia"
  size                            = "Standard_D2s_v4"
  admin_username                  = "adminuser"
  admin_password                  = "Allahu786786@@"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main123.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

}
