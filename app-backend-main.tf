

# Create Security Group to access web
resource "azurerm_network_security_group" "backend-linux-vm-nsg" {
  depends_on=[azurerm_resource_group.network-rg]
  name = "${var.app_name}-${var.environment}-backend-linux-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  security_rule {
    name                       = "allow-ingress-frontend"
    description                = "allow-ingress-frontend"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = azurerm_linux_virtual_machine.frontend-linux-vm.private_ip_address
    destination_address_prefix = azurerm_linux_virtual_machine.backend-linux-vm.private_ip_address
  }
    security_rule {
    name                       = "bastion-ssh"
    description                = "bastion-ssh"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes      = [var.network-subnet-cidr-bastion]
    destination_address_prefix = azurerm_linux_virtual_machine.backend-linux-vm.private_ip_address
  }
    security_rule {
    name                       = "default-deny-ingress"
    description                = "default-deny-ingress"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
      security_rule {
    name                       = "default-deny-egress"
    description                = "default-deny-egress"
    priority                   = 3000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    application = var.app_name
    environment = var.environment
  }
}
# Associate the backend NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "backend-linux-vm-nsg-association" {
  depends_on=[azurerm_network_security_group.backend-linux-vm-nsg]
  subnet_id                 = azurerm_subnet.network-backend-subnet.id
  network_security_group_id = azurerm_network_security_group.backend-linux-vm-nsg.id
}

# Create Network Card for backend VM
resource "azurerm_network_interface" "backend-linux-vm-nic" {
  name = "linux-backend-vm-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-backend-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { 
    application = var.app_name
    environment = var.environment
  }
}
# Create Linux VM with web server
resource "azurerm_linux_virtual_machine" "backend-linux-vm" {
  depends_on=[azurerm_network_interface.backend-linux-vm-nic]
  name = "app-vm-backend"
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  network_interface_ids = [azurerm_network_interface.backend-linux-vm-nic.id]
  size                  = var.web-linux-vm-size
  source_image_reference {
    offer     = lookup(var.web-linux-vm-image, "offer", null)
    publisher = lookup(var.web-linux-vm-image, "publisher", null)
    sku       = lookup(var.web-linux-vm-image, "sku", null)
    version   = lookup(var.web-linux-vm-image, "version", null)
  }
  os_disk {
   name = "linux-backend-vm-os-disk"
   caching              = "ReadWrite"
   storage_account_type = "Standard_LRS"
  }
  computer_name = "linux-backend-vm"
  admin_username = var.web-linux-admin-username
  admin_password = var.web-linux-admin-password
  custom_data = base64encode(data.template_file.linux-vm-backend-init.rendered)
  disable_password_authentication = false
  tags = {
    application = var.app_name
    environment = var.environment
  }
}