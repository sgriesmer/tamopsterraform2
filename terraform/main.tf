provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "tstate21911"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
    access_key           = "yGfoFhhSJwpUS5RHmuE6vru7FT51Py64oPprrzZcs8xbrfVUs4yzizd88DKLyEkHaOCv1q0GSibj1MvoWNDrnQ=="
  }
}

module "resource_group" {
  source               = "./modules/resource_group"
  resource_group       = "${var.resource_group}"
  location             = "${var.location}"
}

module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "./modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
    
module "appservice" {
  source           = "./modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "publicip" {
  source           = "./modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}
# module "vm" {
#  source           = "./modules/vm"
#  subnet_id       = "${module.network.subnet_id_test}"
#  location        = "${var.location}"
#  resource_group   = "${module.resource_group.resource_group_name}"
# }
resource "azurerm_network_interface" "test" {
  name                = "sjg-udacity-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${module.network.subnet_id_test}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${module.publicip.public_ip_address_id}"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "sjg-udacity-vm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_B1s"
  admin_username      = "adminsjg"
  admin_password      = "Try1t^now"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.test.id]
#  admin_ssh_key {
#    username   = "adminsjg"
#    public_key = "file('./az_sjg.pub')"
#  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
    
