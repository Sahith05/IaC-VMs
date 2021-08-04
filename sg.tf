resource "azurerm_network_security_group" "mfs" {
  name                = "nsg-mfs-${var.environment}-${var.location}-001"
  location            = "${azurerm_resource_group.mfs.location}"
  resource_group_name = "${azurerm_resource_group.mfs.name}"

  security_rule {
    name                        = "ssh"
    priority                    = "100"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"   
  }

 tags = {
    Environment = var.environment
    Name = "nsg-mfs-${var.environment}-${var.location}-001"
    Project = "mfs"
    CreatedOnDate = "28-july-2021"
    Department = "cloud-mfs"
    Owner      = "Sahith"
  }
}
resource "azurerm_network_interface_security_group_association" "mfs-pub" {
  network_interface_id      = azurerm_network_interface.mfs-public.id
  network_security_group_id = azurerm_network_security_group.mfs.id
  depends_on = [azurerm_network_interface.mfs-public]
}
resource "azurerm_network_interface_security_group_association" "mfs-pvt" {
  network_interface_id      = azurerm_network_interface.mfs-internal.id
  network_security_group_id = azurerm_network_security_group.mfs.id
  depends_on = [azurerm_network_interface.mfs-internal]
}
