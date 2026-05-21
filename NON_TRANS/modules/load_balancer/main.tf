resource "azurerm_public_ip" "lb" {
  name = "lb-pip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "lb" {
  name = "aswin-lb"
  location = var.location
  resource_group_name = var.resource_group_name
  sku = "Standard"

  frontend_ip_configuration {
    name = "frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "backend-pool"
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "http-probe"
  port = 5656
  protocol = "Tcp"
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "http-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 5656
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.pool.id]
  probe_id = azurerm_lb_probe.probe.id
}