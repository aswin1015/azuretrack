output "load_balancer_id" {
    value = azurerm_lb.lb.id
}

output "backend_pool_id" {
    value = azurerm_lb_backend_address_pool.pool.id
}
