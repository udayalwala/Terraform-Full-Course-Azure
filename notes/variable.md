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


✅ What is a Boolean Variable in Terraform?

A boolean variable in Terraform is a variable that can hold only two values:

true

false

It is used to toggle features or conditions, such as enabling or disabling a service, resource, or specific configuration.

📌 Syntax

```
variable "enable_feature" {
  type        = bool
  description = "Enable or disable a feature"
  default     = false
}
```

📘 Example: Using a Boolean Variable to Enable Boot Diagnostics in Azure

variables.tf

```
variable "enable_diagnostics" {
  type        = bool
  description = "Enable boot diagnostics for the virtual machine"
  default     = false
}
```

terraform.tfvars

```
enable_diagnostics = true
```
main.tf

```
resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = "East US"
  resource_group_name   = "example-rg"
  network_interface_ids = []
  vm_size               = "Standard_B1s"

  # Example of using a boolean variable
  boot_diagnostics {
    enabled     = var.enable_diagnostics
    storage_uri = "https://example.blob.core.windows.net/"
  }

  # ... other required VM config ...
}
```

✅ What is a List Variable in Terraform?

In Terraform, a list variable holds an ordered collection of values, all of the same type — typically strings, numbers, or bools.

Think of it like an array in other languages.

📌 Syntax

```
variable "vm_names" {
  type        = list(string)
  description = "List of virtual machine names"
}
```

🧾 Example: Create Multiple VMs from a List of Names

variables.tf

```
variable "vm_names" {
  type        = list(string)
  description = "List of VM names to create"
}
```
terraform.tfvars

```
vm_names = ["web-vm-1", "web-vm-2", "web-vm-3"]
```
main.tf

```
resource "azurerm_virtual_machine" "example" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  location            = "East US"
  resource_group_name = "example-rg"
  network_interface_ids = []
  vm_size             = "Standard_B1s"

  # ...other required VM configuration...
}
```
🧠 Key Notes
list(string) means a list of strings (["one", "two"])

Use count and count.index to loop over lists

You can also access values directly:

hcl
Copy
Edit
var.vm_names[0]  # "web-vm-1"
var.vm_names[1]  # "web-vm-2"

✅ What is a Set in Terraform?

In Terraform, a set is a collection similar to a list, but with two key differences:

No duplicates allowed

Unordered — the order of elements is not guaranteed

It’s useful when the order doesn’t matter and you want to ensure uniqueness.

📌 Syntax

```
variable "tags_set" {
  type        = set(string)
  description = "Set of tags to apply as keys"
}
```
📘 Example: Using a Set for Azure Resource Tags

variables.tf
```
variable "tags_set" {
  type        = set(string)
  description = "Set of tag keys to assign"
}
```

terraform.tfvars

```
tags_set = ["env", "owner", "department"]
```
main.tf

```
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"

  # Convert set into a map (with dummy values)
  tags = {
    for tag in var.tags_set :
    tag => "true"
  }
}
```

✅ What is a Map in Terraform?

A map in Terraform is a collection of key-value pairs, similar to a dictionary or object in other languages.

Maps are great for grouping related values together — like tags, settings, or resource properties — in a structured way.

📌 Syntax

```
variable "tags" {
  type        = map(string)
  description = "Map of resource tags"
}
```
📘 Example: Using a Map to Set Tags on an Azure Resource Group

variables.tf

```
variable "tags" {
  type        = map(string)
  description = "Tags to assign to the resource"
}
```

terraform.tfvars

```
tags = {
  environment = "dev"
  owner       = "uday"
  team        = "infrastructure"
}
```
main.tf
```
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
  tags     = var.tags
}
```
🧠 Key Characteristics
Feature	Value
Access pattern	var.tags["owner"]
Duplicate keys	❌ Not allowed
Order	Unordered (like a hash)
Use cases	Tags, settings, configs

✅ What is an Object in Terraform?

An object in Terraform is a complex data type that allows you to define a structured group of named attributes, each with its own type.

Think of it like a custom struct or schema with named fields — it's more structured than a map and ideal for nested or related values.

📦 Object vs Map
Feature	Object	Map
Schema	Strict (must match types)	Flexible (all values same type)
Access	var.resource.name	var.resource["name"]
Use case	Structured data like configs	Key-value tags or settings

📌 Syntax

```
variable "vm_config" {
  type = object({
    name     = string
    size     = string
    location = string
  })
  description = "Configuration for an Azure VM"
}
```
📘 Example: Using an Object for VM Configuration

variables.tf

```
variable "vm_config" {
  type = object({
    name     = string
    size     = string
    location = string
  })
  description = "Configuration for the virtual machine"
}
```
terraform.tfvars

```
vm_config = {
  name     = "vm-01"
  size     = "Standard_B1s"
  location = "East US"
}
```
main.tf

```
resource "azurerm_virtual_machine" "example" {
  name                  = var.vm_config.name
  location              = var.vm_config.location
  resource_group_name   = "example-rg"
  network_interface_ids = []
  vm_size               = var.vm_config.size

  # other VM config
}
```
🧠 When to Use Objects
Use an object when:

You have a group of related values

You want strict type enforcement

You want to pass a single variable instead of many separate ones

✅ What is a Tuple in Terraform?

A tuple in Terraform is an ordered collection of values of mixed types.
It is like a list, but each item can be of a different type and position matters.

Think of it like a fixed-length, position-based array where each element has a defined type and position.

📦 Tuple vs List
Feature	Tuple	List
Length	Fixed (defined)	Variable
Types	Can be mixed ([string, number])	Same type only
Access	By index (var.tuple[0])	By index
Use Case	Known structure with mixed types	Repeating same-type items

📌 Syntax
```
variable "my_tuple" {
  type = tuple([string, number, bool])
  description = "A tuple with string, number, and boolean"
}
```
📘 Example: Using a Tuple

variables.tf
```
variable "vm_tuple" {
  type = tuple([string, number, bool])
  description = "Tuple with VM name, size (number of cores), and diagnostics flag"
}
```
terraform.tfvars
```
vm_tuple = ["vm-01", 2, true]
```
main.tf
```
output "vm_name" {
  value = var.vm_tuple[0]
}

output "vm_cores" {
  value = var.vm_tuple[1]
}

output "enable_diagnostics" {
  value = var.vm_tuple[2]
}
```
🧠 When to Use a Tuple
Use a tuple when:

You need mixed data types

You know the exact number and type of elements

You care about position/order of data