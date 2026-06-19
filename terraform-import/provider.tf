provider "azurerm" {
  features {
  }
  subscription_id                 = "c00de6c7-c9b6-40f3-97a4-cbc8d3bdb52f"
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
  resource_provider_registrations = "none"
}
