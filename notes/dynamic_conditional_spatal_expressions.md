🔹 What Is Dynamic expressions in Terraform?

🔁 Dynamic blocks are designed to create nested blocks within a resource or other top-level block types. This is particularly helpful when you have a variable number of similar configurations to define. 


locals.tf
```
locals {
  nsg_rules = {
    "allow_http" = {
      priority               = 100
      destination_port_range = "80"
      description           = "Allow HTTP"
    },
    "allow_https" = {
      priority               = 110
      destination_port_range = "443"
      description           = "Allow HTTPS"
    }
  }
}
```
```
resource "azurerm_resource_group" "rg" {
  name     = "day10-rg"
  location = "westus2"
}
```
main.tf

```
# Create Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Here's where we need the dynamic block
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = security_rule.value.destination_port_range
      source_address_prefix     = "*"
      destination_address_prefix = "*"
      description               = security_rule.value.description
    }
  }
}
```

example2:

✅ locals.tf (Enhanced Rules)

```
locals {
  nsg_rules = {
    "allow_ssh" = {
      priority                = 100
      destination_port_range = "22"
      description             = "Allow SSH"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
    },
    "deny_all_outbound" = {
      priority                = 200
      destination_port_range = "*"
      description             = "Deny all outbound traffic"
      direction               = "Outbound"
      access                  = "Deny"
      protocol                = "*"
    },
    "allow_dns" = {
      priority                = 120
      destination_port_range = "53"
      description             = "Allow DNS (UDP)"
      direction               = "Outbound"
      access                  = "Allow"
      protocol                = "Udp"
    }
  }
}
```

✅ main.tf (Dynamic NSG Rules)

```
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                        = security_rule.key
      priority                    = security_rule.value.priority
      direction                   = security_rule.value.direction
      access                      = security_rule.value.access
      protocol                    = security_rule.value.protocol
      source_port_range           = "*"
      destination_port_range      = security_rule.value.destination_port_range
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      description                 = security_rule.value.description
    }
  }
}
```

You Can Now Easily Add Rules Like:

```
"allow_http" = {
  priority                = 130
  destination_port_range = "80"
  description             = "Allow HTTP"
  direction               = "Inbound"
  access                  = "Allow"
  protocol                = "Tcp"
}
```

🔹 What Is a Ternary Expression in Terraform?

A ternary expression is a conditional expression in Terraform that lets you assign a value based on a condition, using this format:
```
condition ? true_value : false_value
```

var.tf
```
variable "environment" {
  type = string
  description = "Environment name (ex. dev, prod, staging)"
  default = "dev"
}
```
main.tf
```
provider "azurerm" {
    features {

    }

}
resource "azurerm_resource_group" "examplerg" {
  name     = "udayrg1"
  location = "eastus"
}
resource "azurerm_network_security_group" "example" {
  name                = (var.environment == "dev" ? "dev-nsg" : "stage-nsg")
  location            = azurerm_resource_group.examplerg.location
  resource_group_name = azurerm_resource_group.examplerg.name
}
```

🔹 what are splat expressions in terraform?

The splat expression is used to extract values from complex data structures, particularly when working with lists and maps. It allows you to access specific elements within a list or map and use them in your Terraform configurations.

Extracting List Elements

When you have a list of values, you can use the splat expression to extract specific elements from the list. The syntax is as follows

```
variable "example_list" {
  type    = list(string)
  default = ["value1", "value2", "value3"]
}

output "selected_value" {
  value = var.example_list[1] // Accessing the second element using index
}
```

Extracting Map Values

Similarly, the splat expression can be used to extract values from a map

```
variable "example_map" {
  type    = map(string)
  default = { key1 = "value1", key2 = "value2", key3 = "value3" }
}

output "selected_value" {
  value = var.example_map["key2"] // Accessing the value associated with "key2"
}
```
