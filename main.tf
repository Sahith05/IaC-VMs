provider "azurerm" {
  features {}

  #subscription_id = var.subscription_id
  #tenant_id       =  var.tenant_id
}

resource "azurerm_resource_group" "mfs" {
  name     = "rg-mfs-${var.environment}-${var.location}-001"
  location = "West US 2"
  tags = {
    Environment = var.environment
    Name = "rg-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}

resource "azurerm_virtual_network" "mfs" {
  name                = "vnet-mfs-${var.environment}-${var.location}-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mfs.location
  resource_group_name = azurerm_resource_group.mfs.name
    tags = {
    Environment = var.environment
    Name = "vnet-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}
resource "azurerm_subnet" "mfs-internal" {
  name                 = "snet-mfs-${var.environment}-${var.location}-001"
  #location            = azurerm_resource_group.mfs.location
  
  virtual_network_name = azurerm_virtual_network.mfs.name
  resource_group_name = azurerm_resource_group.mfs.name
  address_prefixes     = ["10.0.1.0/24"]
  #network_security_group_id      = azurerm_network_security_group.mfs.id
}

resource "azurerm_nat_gateway" "mfs" {
  name                =  "nat-mfs-${var.environment}-${var.location}-001"
  location            = azurerm_resource_group.mfs.location
  resource_group_name = azurerm_resource_group.mfs.name
    tags = {
    Environment = var.environment
    Name = "nat-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}

resource "azurerm_subnet_nat_gateway_association" "mfs" {
  subnet_id      = azurerm_subnet.mfs-internal.id
  nat_gateway_id = azurerm_nat_gateway.mfs.id
}

resource "azurerm_subnet" "mfs-public" {
  name                 = "snet-mfs-${var.environment}-${var.location}-002"
  resource_group_name  = azurerm_resource_group.mfs.name
  virtual_network_name = azurerm_virtual_network.mfs.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public-ip" {
  name                          = "pip-mfs-${var.environment}-${var.location}-001"
 location            = azurerm_resource_group.mfs.location
  resource_group_name = azurerm_resource_group.mfs.name
  allocation_method = "Static"
   tags = {
    Environment = var.environment
    Name = "pip-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}
resource "azurerm_network_interface" "mfs-internal" {
  name                = "nic-mfs-${var.environment}-${var.location}-002"
 location            = azurerm_resource_group.mfs.location
  resource_group_name = azurerm_resource_group.mfs.name

  ip_configuration {
    name                          = "ipconfig-mfs-${var.environment}-${var.location}-001"
    subnet_id                     = azurerm_subnet.mfs-internal.id
    private_ip_address_allocation = "Dynamic"
  }
   tags = {
    Environment = var.environment
    Name = "nic-mfs-${var.environment}-${var.location}-002"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}

resource "azurerm_network_interface" "mfs-public" {
  name                = "nic-mfs-${var.environment}-${var.location}-001"
 location            = azurerm_resource_group.mfs.location
  resource_group_name = azurerm_resource_group.mfs.name

  ip_configuration {
    name                          = "pip-mfs-${var.environment}-${var.location}-001"
    subnet_id                     = azurerm_subnet.mfs-public.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Environment = var.environment
    Name = "pip-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }

}
resource "azurerm_virtual_machine" "mfs" {
  name                  = "vm-mfs-${var.environment}-${var.location}-001"
  location                      = azurerm_resource_group.mfs.location
  resource_group_name           = azurerm_resource_group.mfs.name
  network_interface_ids = [azurerm_network_interface.mfs-internal.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "${element(split("/", var.vm_image_string), 0)}"
    offer     = "${element(split("/", var.vm_image_string), 1)}"
    sku       = "${element(split("/", var.vm_image_string), 2)}"
    version   = "${element(split("/", var.vm_image_string), 3)}"
  }

  storage_os_disk {
    name              = "osdisk-mfs-${var.environment}-${var.location}-001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 100
  }

  os_profile {
    computer_name  = "osp-mfs-${var.environment}-${var.location}-001"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Environment = var.environment
    Name = "vm-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }

}

