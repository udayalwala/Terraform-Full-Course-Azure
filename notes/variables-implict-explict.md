Implicit Dependency

Terraform automatically understands the order of resource creation based on references between resources. If one resource uses an attribute of another, Terraform creates a dependency graph.

resource "azurerm_resource_group" "rg" {
  name     = "my-rg"
  location = "East US"
}

resource "azurerm_storage_account" "sa" {
  name                     = "mystorageacct"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

Here, the storage account implicitly depends on the resource group because it uses azurerm_resource_group.rg.name and location. Terraform sees this reference and ensures the resource group is created before the storage account.

explict dependency

You create an Azure Resource Group and a Storage Account.
You want to log a message only after the Storage Account is created, even though the logging resource does not reference it directly.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct1"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "null_resource" "log_after_storage" {
  depends_on = [azurerm_storage_account.example]

  provisioner "local-exec" {
    command = "echo 'Storage Account is now created.'"
  }
}


null_resource.log_after_storage does not use any attribute from the storage account.
depends_on = [azurerm_storage_account.example]

you tell Terraform explicitly to wait until the storage account is created.

