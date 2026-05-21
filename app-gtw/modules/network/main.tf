resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = var.vnet_address_space
  location = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "appgw" {
  name = "appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.appgw_subnet_prefixes
}

resource "azurerm_subnet" "backend" {
  name = "backend-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.backend_subnet_prefixes
}