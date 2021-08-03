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

resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

