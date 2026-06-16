terraform {
  required_version = ">= 1.5"

  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstateazel01" # <- your actual storage account name
    container_name       = "tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}