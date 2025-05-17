string variable:
===================

In Terraform, a string variable is used to define and store plain text values — such as names, regions, or any textual configuration that your infrastructure may require.


```
variable "variable_name" {
  type        = string
  description = "Description of the variable"
  default     = "default_value" # (Optional)
}
```

Example: String Variable in Azure Resource Creation

variables.tf

```
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}
```

terraform.tfvars

```
resource_group_name = "my-terraform-rg"
```

main.tf

```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "East US"
}
```