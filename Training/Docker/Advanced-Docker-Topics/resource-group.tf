# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.student}-Advanced-Docker-Topics"
  location = "${var.location}"
}
