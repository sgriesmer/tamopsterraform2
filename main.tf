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

resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}


