resource "azurerm_subnet" "subnet" {
    name                 = "default"
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "bastion" {
    name = "AzureBastionSubnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes = ["10.0.2.0/26"]
}