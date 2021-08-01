provider "azurerm" {
    features {}
}

terraform {
        backend "azurerm" {
            storage_account_name = "tamopstf2121"
            container_name       = "tfstatedevops"
            key                  = "terraform.tfstate"
            access_key           = "eLOs0wXAtFmH5kwOAS0SJiUsWVLt9cleqDoDYiAcYa2GWZPFA1v8yQj335Vp7KGAgL6e+LWrUi27ybwMcPwsNw=="
            }
        }

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "tamops-tf"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "tamopssatf1278"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
