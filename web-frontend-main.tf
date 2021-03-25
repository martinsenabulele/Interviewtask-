
# Create Security Group to access web
resource "azurerm_network_security_group" "frontend-linux-vm-nsg" {
  depends_on = [azurerm_resource_group.network-rg]
  name = "${var.app_name}-${var.environment}-frontend-linux-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
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
    destination_address_prefix = azurerm_linux_virtual_machine.frontend-linux-vm.private_ip_address
  }
    security_rule {
    name                       = "allow-egress-backend-ssh"
    description                = "allow-egress-backend-ssh"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = azurerm_linux_virtual_machine.backend-linux-vm.private_ip_address
    destination_address_prefix = "*"
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
# Get a Static Public IP
resource "azurerm_public_ip" "web-linux-vm-ip" {
  depends_on=[azurerm_resource_group.network-rg]
  name = "linux-vm-ip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
  
  tags = { 
    environment = var.environment
  }
}
# Associate the web NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "frontend-linux-vm-nsg-association" {
  depends_on=[azurerm_network_security_group.frontend-linux-vm-nsg]
  subnet_id                 = azurerm_subnet.network-frontend-subnet.id
  network_security_group_id = azurerm_network_security_group.frontend-linux-vm-nsg.id
}

# Create Network Card for web VM
resource "azurerm_network_interface" "frontend-linux-vm-nic" {
  name = "linux-frontend-vm-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-frontend-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.web-linux-vm-ip.id
  }
  tags = { 
    application = var.app_name
    environment = var.environment
  }
}

# Create Linux VM with web server
resource "azurerm_linux_virtual_machine" "frontend-linux-vm" {
  depends_on=[azurerm_network_interface.frontend-linux-vm-nic]
  name = "web-vm-frontend"
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  network_interface_ids = [azurerm_network_interface.frontend-linux-vm-nic.id]
  size                  = var.web-linux-vm-size
  source_image_reference {
    offer     = lookup(var.web-linux-vm-image, "offer", null)
    publisher = lookup(var.web-linux-vm-image, "publisher", null)
    sku       = lookup(var.web-linux-vm-image, "sku", null)
    version   = lookup(var.web-linux-vm-image, "version", null)
  }
  os_disk {
   name = "linux-frontend-vm-os-disk"
   caching              = "ReadWrite"
   storage_account_type = "Standard_LRS"
  }
  computer_name = "linux-frontend-vm"
  admin_username = var.web-linux-admin-username
  admin_password = var.web-linux-admin-password
  custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  disable_password_authentication = false
  tags = {
    application = var.app_name
    environment = var.environment
  }
}