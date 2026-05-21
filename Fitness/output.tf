output resource_group_name {
    value = azurerm_resource_group.rg.name
}

output public_location {
    value = azurerm_resource_group.rg.location
}

output private_location {
    value = azurerm_resource_group.rg.location
}

output public_vnet_name {
    value = azurerm_virtual_network.public_vnet.name
}

output private_vnet_name {
    value = azurerm_virtual_network.private_vnet.name
}

output public_subnet_name {
    value = azurerm_subnet.public_subnet.name
}

output private_subnet_name {
    value = azurerm_subnet.private_subnet.name
}

output vnet_peering_name {
    value = azurerm_virtual_network_peering.vnet_peering.name
}

output public_vm_size {
    value = azurerm_linux_virtual_machine.public_vm.size
}

output private_vm_size {
    value = azurerm_linux_virtual_machine.private_vm.size
}

output public_vm_name {
    value = azurerm_linux_virtual_machine.public_vm.name
}

output private_vm_name {
    value = azurerm_linux_virtual_machine.private_vm.name
}

output admin_username {
    value = azurerm_linux_virtual_machine.public_vm.admin_username
}