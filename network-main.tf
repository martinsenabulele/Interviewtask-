# Create a resource group for network
resource "azurerm_resource_group" "network-rg" {
  name     = "${var.app_name}-${var.environment}-rg"
  location = var.location
  tags = {
    application = var.app_name
    environment = var.environment
  }
}
# Create the network VNET
resource "azurerm_virtual_network" "network-vnet" {
  name                = "${var.app_name}-${var.environment}-vnet"
  address_space       = [var.network-vnet-cidr]
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
  tags = {
    application = var.app_name
    environment = var.environment
  }
}
# Create a subnet for frontend Network
resource "azurerm_subnet" "network-frontend-subnet" {
  name                 = "${var.app_name}-${var.environment}-frontend-subnet"
  address_prefixes     = [var.network-subnet-cidr-frontend]
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

# Create a subnet for backend Network
resource "azurerm_subnet" "network-backend-subnet" {
  name                 = "${var.app_name}-${var.environment}-backend-subnet"
  address_prefixes     = [var.network-subnet-cidr-backend]
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

# Create a subnet for Bastion
resource "azurerm_subnet" "network-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  address_prefixes     = [var.network-subnet-cidr-bastion]
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name
}

