resource "azurerm_monitor_action_group" "email_alert" {
    name = "email_action_group"
    resource_group_name = var.resource_group_name
    short_name = "alerts"
  email_receiver {
    name = "admin-email"
    email_address = var.email_address
  }
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
    name = "CPU_alert"
    resource_group_name = var.resource_group_name

    scopes = [var.vmss_id]

  description = "Alert for high CPU usage"

  severity = 2
  frequency = "PT1M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name = "Percentage CPU"
    aggregation = "Average"
    operator = "GreaterThan"
    threshold = 40
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
    }

}