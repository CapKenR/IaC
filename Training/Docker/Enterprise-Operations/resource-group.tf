# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.student}-Docker-Enterprise-Operations"
  location = "${var.location}"
}
