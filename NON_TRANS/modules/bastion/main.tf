resource "azurerm_public_ip" "bastion" {
    name = "bastion_pip"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
    name = "bast"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "configuration"
        subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/AzureBastionSubnet"
        public_ip_address_id = azurerm_public_ip.bastion.id


    }
}

data "azurerm_client_config" "current" {}