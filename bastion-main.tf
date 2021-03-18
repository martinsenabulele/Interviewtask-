#Create a static public IP for bastion vm
resource "azurerm_public_ip" "bastion_public_ip" {
  depends_on=[azurerm_resource_group.network-rg]
  name                = "bastion_public_ip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
    tags = { 
    application = var.app_name
    environment = var.environment
  }
}

#creating a bastion-vm
resource "azurerm_bastion_host" "bastion-vm" {
  name                = "bastion-vm"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.network-bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}