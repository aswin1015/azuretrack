resource "azurerm_web_application_firewall_policy" "this" {
  name = "nexus-waf-policy"
  location = var.location
  resource_group_name = var.resource_group_name

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}