resource "azurerm_resource_group" "example" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "example" {
    name = var.vnet_name
    address_space = var.vnet_address_space
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
}

resource "azurerm_subnet" "example" {
    name = var.subnet_name
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes = var.subnet_prefixes
}

resource "azurerm_public_ip" "example" {
    name = var.public_ip_name
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_network_security_group" "example" {
    name = var.nsg_name
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "example" {
    name = var.nic_name
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.example.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.example.id
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id  = azurerm_network_interface.example.id
    network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "example" {
    name = var.vm_name
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    zone = var.zone
    size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.example.id ]

    os_disk {
        name = "myosdisk"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
}
