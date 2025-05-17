✅ What is a String Variable in Terraform?

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

✅ What is a Number Variable in Terraform?

A number variable in Terraform is used to represent numeric values — integers or floating-point numbers. You can use it for things like the number of resource instances, size of disks, port numbers, etc.

```
variable "variable_name" {
  type        = number
  description = "Description of the number variable"
  default     = 1  # optional
}
```

📘 Example: Number Variable in Azure VM Count

variables.tf

```
variable "vm_count" {
  type        = number
  description = "Number of virtual machines to create"
}
```

terraform.tfvars

```
vm_count = 2
```

main.tf

```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  count               = var.vm_count
  name                = "example-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
```
 
🧠 Key Points
Type: number allows only numeric input (no quotes).

Usage: Great for count, size, or configuration parameters.

Access: Use var.vm_count in your configuration.

🔍 What is:

```
name = "example-nic-${count.index}"
```
This line uses Terraform interpolation syntax to dynamically name resources when using the count meta-argument.

example-nic-: This is a fixed string prefix for the name.

${count.index}: This is a built-in variable that gives the current index of the resource in the loop (starting from 0).

"example-nic-${count.index}": This results in names like:

example-nic-0

example-nic-1

example-nic-2

... depending on count

```
resource "azurerm_network_interface" "example" {
  count = 3
  name  = "example-nic-${count.index}"
  # ...
}
```

Terraform will create 3 NICs with these names:

example-nic-0

example-nic-1

example-nic-2

"example-nic-${count.index}" is a way to dynamically generate unique names in a loop when using count in a Terraform resource block. It's especially useful when creating multiple similar resources