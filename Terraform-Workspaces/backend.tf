terraform {
  backend "azurerm" {
    resource_group_name  = "ash-rg"
    storage_account_name = "storageaccountaswin"
    container_name       = "ashcontainer"
    key                  = "terraform.tfstate"
  }
}