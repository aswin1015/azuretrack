output "nat_public_ip" {
  value = azurerm_public_ip.nat_pip.ip_address
}