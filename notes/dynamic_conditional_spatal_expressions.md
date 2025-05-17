

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