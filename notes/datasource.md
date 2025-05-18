✅ What is a Data Source in Terraform (Azure context)?

In Terraform, a data source allows you to read information from existing resources that are not managed by your Terraform code, or resources you need to reference before creating others.

 🔍 Why Use Data Sources?
To look up existing resources like:

Resource groups

Subnets

Key vault secrets

Storage accounts

To get dynamic information needed for resource creation

To avoid hardcoding values

🏗️ Example: Get an Existing Azure Resource Group

```
data "azurerm_resource_group" "example" {
  name = "my-existing-rg"
}

output "location" {
  value = data.azurerm_resource_group.example.location
}
```

You can now reference the existing RG's properties in other resources:

```
resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```