Implicit Dependency
===================

Terraform automatically understands the order of resource creation based on references between resources. If one resource uses an attribute of another, Terraform creates a dependency graph.

Terraform Example (HCL)

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
In this example, the storage account implicitly depends on the resource group because it references azurerm_resource_group.rg.name and azurerm_resource_group.rg.location. Terraform detects this reference and ensures the resource group is created before the storage account.

Explicit Dependency
=======================
When there is no direct reference between resources, but a specific order is required, Terraform allows you to explicitly define dependencies using the depends_on argument.

Terraform Example (HCL)

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
Here, null_resource.log_after_storage does not use any output from the storage account, so Terraform would not infer a dependency. By using:

hcl
Copy
Edit
depends_on = [azurerm_storage_account.example]
you explicitly tell Terraform to wait until the storage account is created before executing the local-exec provisioner.
 
