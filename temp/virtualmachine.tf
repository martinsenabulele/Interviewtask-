#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#additional_unattend_content

#Issue observed is that creating VM using GUI creates Security Group and assigns public IP. through terraform securityGroup is not created by default
#assume that we need to manually create security group and assign to VM. 

#In this release there is an issue where public IP configuration cannot be provided. 

resource "azurerm_virtual_network" "tf_vnet" {
  name                = "tf_vm"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name
}

resource "azurerm_subnet" "tf_subnet" {
  name                 = "tf"
  resource_group_name  = azurerm_resource_group.tf_rg.name
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tf_nic_interface" {
  name                = "tf-nic"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
#Network security group also is not part of the module. there is a  Need to check for the way to connect NSG to VM./ vNET
resource "azurerm_windows_virtual_machine" "tf_vm" {
  name                = "tf-vm"
  resource_group_name = azurerm_resource_group.tf_rg.name
  location            = azurerm_resource_group.tf_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.tf_nic_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}