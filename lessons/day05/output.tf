terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstatefilesrg"
      storage_account_name = "tfstatefilesc"
      container_name       = "tfstate"
      key                  = "demo.terraform.tfstate"
  }
  required_version = ">= 1.12.0"
}

provider "azurerm" {
  features {}

}
variable "environment" {
  type = string
  description = "environment stage"
  default = "staging"
  
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "azurelearningsbyudai"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
  }
}
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
