terraform {
  backend "azurerm" {
    resource_group_name  = "aswin-state-rg"
    storage_account_name = "sttfaswinstate"
    container_name       = "tfstateaswin"
    key                  = "terraform-depend.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

