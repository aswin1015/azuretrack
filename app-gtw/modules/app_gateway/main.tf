resource "azurerm_public_ip" "this" {
  name = "appgtw-pip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_application_gateway" "this" {

  name = "app-gtw"
  location = var.location
  resource_group_name = var.resource_group_name

  firewall_policy_id = var.waf_policy_id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    capacity = 2
  }

  ssl_policy {
  policy_type = "Predefined"
  policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = "backend-app1"
    ip_addresses = [var.backend1_private_ip]
  }

  backend_address_pool {
    name = "backend-app2"
    ip_addresses = [var.backend2_private_ip]
  }


  backend_http_settings {
    name = "bhs-app1"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 60
    probe_name = "probe-app1"
  }

  backend_http_settings {
    name = "bhs-app2"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 60
    probe_name = "probe-app2"
  }


  probe {
    name = "probe-app1"
    protocol = "Http"
    path = "/"
    interval = 30
    timeout = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = false
    host = "127.0.0.1"
  }

  probe {
    name = "probe-app2"
    protocol = "Http"
    path = "/"
    interval = 30
    timeout = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = false
    host = "127.0.0.1"
  }


  http_listener {
    name = "listener-app1"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name = "http-port"
    protocol = "Http"
    host_name = "app1.b4n3xus.in"
  }

  http_listener {
    name = "listener-app2"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name = "http-port"
    protocol = "Http"
    host_name = "app2.b4n3xus.in"
  }



  request_routing_rule {
    name = "rule-app1"
    rule_type = "Basic"
    priority = 100

    http_listener_name = "listener-app1"
    backend_address_pool_name  = "backend-app1"
    backend_http_settings_name = "bhs-app1"
  }

  request_routing_rule {
    name = "rule-app2"
    rule_type = "Basic"
    priority = 101

    http_listener_name = "listener-app2"
    backend_address_pool_name  = "backend-app2"
    backend_http_settings_name = "bhs-app2"
  }

}