resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
    name = "app"
    location = var.location
    resource_group_name = var.resource_group_name
    sku = "Standard_DC1ds_v3"
    instances = 2
    admin_username = "aswin1015"
    disable_password_authentication = false
    admin_password = var.admin_password

    custom_data = base64encode(file("${path.root}/scripts/bootstrap.sh"))

    upgrade_mode = "Automatic"

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku   = "22_04-lts-gen2"
        version = "latest"
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    network_interface {
        name = "app-nic"
        primary = true
        ip_configuration {
            name = "internal"
            primary = true
            subnet_id = var.subnet_id
            load_balancer_backend_address_pool_ids = [var.backend_pool_id]
        }
    }


}