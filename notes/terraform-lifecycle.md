terraform Lifecycle:

create before destory: Before destory the resources, it will create a new resource

main.tf
```
provider "azurerm" {
    features {

    }

}
resource "azurerm_resource_group" "examplerg" {
  name     = "udayrg"
  location = var.location
}
resource "azurerm_public_ip" "publicip" {
  name = "public-ip-example"
  resource_group_name = azurerm_resource_group.examplerg.name
  location = var.location
  allocation_method = "Static"
  lifecycle {
    create_before_destroy = true
  }
}
```

vars.tf

```
variable "location" {
  type        = string
  description = "Name of the location"
}
```
terraform.tfvars

```
location="eastus"
```

If you change the name = "public-ip-example" to name = "public-ip-example1", it will create public-ip-example1 and delete public-ip-example this will minimize downtime/zero