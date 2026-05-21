resource "azurerm_monitor_autoscale_setting" "autoscale" {
    name = "appautoscale"
    location = var.location
    resource_group_name = var.resource_group_name
    target_resource_id = var.vmss_id

    profile {
        name = "default"

        capacity {
            default = 2
            minimum = 2
            maximum = 5
        }

        rule {
            metric_trigger {
                metric_name = "Percentage CPU"
                metric_resource_id = var.vmss_id
                time_grain = "PT1M"
                statistic = "Average"
                time_window = "PT1M"
                time_aggregation = "Average"
                operator = "GreaterThan"
                threshold = 50
            }

            scale_action {
                direction = "Increase"
                type = "ChangeCount"
                value = 1
                cooldown = "PT1M"
        }
        }

        rule {

            metric_trigger {

                metric_name        = "Percentage CPU"
                metric_resource_id = var.vmss_id

                time_grain       = "PT1M"
                statistic        = "Average"
                time_window      = "PT1M"
                time_aggregation = "Average"

                operator  = "LessThan"
                threshold = 20
      }

            scale_action {

                direction = "Decrease"
                type      = "ChangeCount"
                value     = "1"

                cooldown = "PT1M"
      }
    }
    }
}