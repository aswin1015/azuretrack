resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.public_location
  
}

resource "azurerm_virtual_network" "public_vnet" {
    name = var.public_vnet_name
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "private_vnet" {
    name = var.private_vnet_name
    address_space = ["10.1.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public_subnet" {
    name = var.public_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.public_vnet.name
    address_prefixes = var.public_subnet_prefix
} 

resource "azurerm_subnet" "private_subnet" {
    name = var.private_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.private_vnet.name
    address_prefixes = var.private_subnet_prefix
}

resource "azurerm_virtual_network_peering" "vnet_peering" {
    name = var.vnet_peering_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.public_vnet.name
    remote_virtual_network_id = azurerm_virtual_network.private_vnet.id
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    allow_virtual_network_access = true
}

resource "azurerm_public_ip" "natgateway_public_ip" {
    name = var.natgateway_public_ip_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_nat_gateway" "natgateway" {
    name = var.natgateway_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natgateway_association" {
    nat_gateway_id = azurerm_nat_gateway.natgateway.id
    public_ip_address_id = azurerm_public_ip.natgateway_public_ip.id

}

resource "azurerm_subnet_nat_gateway_association" "public_subnet_natgateway_association" {
    subnet_id = azurerm_subnet.public_subnet.id
    nat_gateway_id = azurerm_nat_gateway.natgateway.id
}

resource "azurerm_network_interface" "public_nic" {
    name = "${var.public_vm_name}-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "${var.public_vm_name}-ipconfig"
        subnet_id = azurerm_subnet.public_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.natgateway_public_ip.id
    }
}

resource "azurerm_network_interface" "private_nic" {
    name = "${var.private_vm_name}-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "${var.private_vm_name}-ipconfig"
        subnet_id = azurerm_subnet.private_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "public_vm" {
    name = var.public_vm_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = var.public_vm_size
    zone = "2"
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = [
        azurerm_network_interface.public_nic.id,
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
}

resource "azurerm_linux_virtual_machine" "private_vm" {
    name = var.private_vm_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = var.private_vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = [
        azurerm_network_interface.private_nic.id,
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
}

