resource "azurerm_network_security_group" "backend" {
  name  = "backend-nsg"
  location  = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name = "Allow-HTTP"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "Allow-SSH"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id = var.backend_subnet_id
  network_security_group_id = azurerm_network_security_group.backend.id
}