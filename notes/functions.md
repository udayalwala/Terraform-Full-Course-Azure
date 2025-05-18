Console Commands

Practice these fundamental commands in terraform console before starting the assignments:

```
# Basic String Manipulation
upper("HELlo WORld")  o/p: "HELLO WORLD"
max(5, 12, 9)
trim("  hello ", "lo" )  o/p: hel   # removes substring
chomp("hello\n")
reverse(["a", "b", "c"])
replace("Hello World", " ", "-")   o/p: "Hello-World"
lower("Hello-world")   o/p: "hello-world"
```

✅ 1. merge function: merge 2 maps 

```
provider "azurerm" {
    features {

    }

}
locals {
  map1 = {
    name  = "App1"
    owner = "Alice"
  }

  map2 = {
    owner = "Bob"
    cost  = "100"
  }

  result = merge(local.map1, local.map2)
}

output "localresult" {
  value = local.result
}

```

o/p: localresult = {
      + cost  = "100"
      + name  = "App1"
      + owner = "Bob"
    }


✅ 2. Join: Build Resource Name

```
provider "azurerm" {
    features {

    }

}
locals {
  name_parts = ["prod", "network", "vnet"]
  vnet_name  = join("-", local.name_parts) # "prod-network-vnet"
}
output "joinoutput" {
  value = local.vnet_name
}

```
o/p: "prod-network-vnet"

✅ 3. split: Break a part

```
provider "azurerm" {
    features {

    }

}
locals {
  full_name = "prod-rg-eastus"
  parts     = split("-", local.full_name)  # ["prod", "rg", "eastus"]
}
output "splitoutput" {
  value = local.parts
}
```

splitoutput = [
      + "prod",
      + "rg",
      + "eastus",
    ]

✅ 4. format() – Create Structured Names

```
provider "azurerm" {
    features {

    }

}
variable "env" {
  default = "dev"
}

variable "location" {
  default = "westeurope"
}

locals {
  rg_name = format("rg-%s-%s", var.env, var.location)  # "rg-dev-westeurope"
}
output "structurednames" {
  value = local.rg_name
}
```

o/p: structurednames = "rg-dev-westeurope"

✅ 5. lookup() – Get Location by Env

```
provider "azurerm" {
    features {

    }

}
variable "env" {
  default = "stage"
}

locals {
  locations = {
    dev  = "westeurope"
    prod = "eastus"
  }

  selected_location = lookup(local.locations, var.env, "centralus")  # "eastus"
}

output "selected_location" {
  value = local.selected_location
}
```

o/p: centralus

✅ 6. contains() – Validate Environment

```
provider "azurerm" {
    features {

    }

}
variable "env" {
  default = "qa"
}

locals {
  allowed_envs = ["dev", "stage", "prod"]
  is_valid     = contains(local.allowed_envs, var.env)  # false
}

output "validateenv" {
  value = local.is_valid
}
```

✅ 7. length() – Check Number of Tags

```
provider "azurerm" {
    features {

    }

}
locals {
  tags = {
    env     = "prod"
    project = "alpha"
  }

  tag_count = length(local.tags)  # 2
}

output "tagcount" {
  value = local.tag_count
}
```
o/p: "tagcount" = 2