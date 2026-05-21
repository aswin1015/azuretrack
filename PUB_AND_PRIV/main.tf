resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    address_space = var.vnet_address_space
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public_subnet" {
    name = var.public_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.public_subnet_address_prefixes
}

resource "azurerm_subnet" "priv" {
    name = var.private_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.private_subnet_address_prefixes
}

resource "azurerm_public_ip" "pubvm_pip" {
    name = var.pubvm_public_ip_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_network_security_group" "pubvm_nsg" {
    name = var.pubvm_nsg_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

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

    security_rule {
        name= "HTTP"
        priority = 1002
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "pubvm_nic" {
    name = var.pubvm_nic_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration{
        name = "internal"
        subnet_id = azurerm_subnet.public_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.pubvm_pip.id
        }
}

resource "azurerm_network_interface_security_group_association" "pubvm_nic_nsg_assoc" {
    network_interface_id = azurerm_network_interface.pubvm_nic.id
    network_security_group_id = azurerm_network_security_group.pubvm_nsg.id
}

resource "azurerm_linux_virtual_machine" "pubvm" {
    name = var.pubvm_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    zone = "2"
    size = var.pubvm_size
    admin_username = var.pubvm_admin_username
    admin_password = var.pubvm_admin_password
    disable_password_authentication = false
    network_interface_ids = [azurerm_network_interface.pubvm_nic.id]

    os_disk{
        name = "${var.pubvm_name}-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
       }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
}

resource "azurerm_public_ip" "lb_pip" {
    name = var.LB_public_ip_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_lb" "lb" {
    name = var.LB_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard"

    frontend_ip_configuration {
        name = var.LB_frontend_ip_configuration_name
        public_ip_address_id = azurerm_public_ip.lb_pip.id
        }

}

resource "azurerm_lb_backend_address_pool" "lb_bap" {
    name = var.LB_backend_address_pool_name
    loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
    name = var.LB_probe_name
    loadbalancer_id = azurerm_lb.lb.id
    protocol = "Tcp"
    port = 80
}

resource "azurerm_lb_rule" "lb_rule" {
    name = var.LB_rule_name
    loadbalancer_id = azurerm_lb.lb.id
    protocol = "Tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = var.LB_frontend_ip_configuration_name
    backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_bap.id]
    probe_id = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_network_security_group" "privm_nsg" {
    name = var.privm_nsg_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name = "AllowLBProbe"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "privm_nic" {
    name = var.privm_nic_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration{
        name = "internal"
        subnet_id = azurerm_subnet.priv.id
        private_ip_address_allocation = "Dynamic"
        }
}

resource "azurerm_network_interface_backend_address_pool_association" "privm_lb_assoc" {
    network_interface_id    = azurerm_network_interface.privm_nic.id
    ip_configuration_name   = "internal"
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb_bap.id
}

resource "azurerm_network_interface_security_group_association" "privm_nic_nsg_assoc" {
    network_interface_id = azurerm_network_interface.privm_nic.id
    network_security_group_id = azurerm_network_security_group.privm_nsg.id
}

resource "azurerm_linux_virtual_machine" "privm" {
    name = var.privm_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    zone = "2"
    size = var.privm_size
    admin_username = var.privm_admin_username
    admin_password = var.privm_admin_password
    disable_password_authentication = false
    network_interface_ids = [azurerm_network_interface.privm_nic.id]

    os_disk{
        name = "${var.privm_name}-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
       }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
}