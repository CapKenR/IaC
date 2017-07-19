resource "azurerm_storage_account" "storageaccount" {
  name                = "${var.user}betastorage"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  storage_account_name  = "${azurerm_storage_account.storageaccount.name}"
  container_access_type = "private"
}

resource "azurerm_storage_share" "registryshare" {
  name = "registry"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  storage_account_name  = "${azurerm_storage_account.storageaccount.name}"
}

resource "azurerm_storage_share" "volumeshare" {
  name = "volume"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  storage_account_name  = "${azurerm_storage_account.storageaccount.name}"
}