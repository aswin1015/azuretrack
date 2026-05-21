output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}