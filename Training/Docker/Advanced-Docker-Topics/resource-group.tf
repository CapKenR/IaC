# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.user}-Advanced-Docker-Topics"
  location = "${var.location}"
}
