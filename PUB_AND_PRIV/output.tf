output resource_group_name {
    value = azurerm_resource_group.rg.name
}

output virtual_network_name {
    value = azurerm_virtual_network.vnet.name
}

output public_subnet_name {
    value = azurerm_subnet.public_subnet.name
}

output pubvm_public_ip {
    value = azurerm_public_ip.pubvm_pip.ip_address
}

output pubvm_nsg_name {
    value = azurerm_network_security_group.pubvm_nsg.name
}

output pubvm_nic_name {
    value = azurerm_network_interface.pubvm_nic.name
}

output pubvm_name {
    value = azurerm_linux_virtual_machine.pubvm.name
}

output pubvm_size {
    value = azurerm_linux_virtual_machine.pubvm.size
}

output privm_nsg_name {
    value = azurerm_network_security_group.privm_nsg.name
}

output privm_nic_name {
    value = azurerm_network_interface.privm_nic.name
}

output privm_name {
    value = azurerm_linux_virtual_machine.privm.name
}

output privm_size {
    value = azurerm_linux_virtual_machine.privm.size
}

output LB_public_ip {
    value = azurerm_public_ip.lb_pip.ip_address
}

output LB_name {
    value = azurerm_lb.lb.name
}

output LB_frontend_ip_configuration_name {
    value = azurerm_lb.lb.frontend_ip_configuration[0].name
}

output LB_backend_address_pool_name {
    value = azurerm_lb_backend_address_pool.lb_bap.name
}

output LB_probe_name {
    value = azurerm_lb_probe.lb_probe.name
}

output LB_rule_name {
    value = azurerm_lb_rule.lb_rule.name
}

