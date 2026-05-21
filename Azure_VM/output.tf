output resource_group_name {
    value = azurerm_resource_group.example.name
}

output public_ip_address {
    value = azurerm_public_ip.example.ip_address
}

output vm_id {
    value = azurerm_linux_virtual_machine.example.id
}

output vm_size {
    value = azurerm_linux_virtual_machine.example.size
}

output admin_username {
    value = azurerm_linux_virtual_machine.example.admin_username
}

output zone {
    value = azurerm_linux_virtual_machine.example.zone
}

output subnet_id {
    value = azurerm_subnet.example.id
}