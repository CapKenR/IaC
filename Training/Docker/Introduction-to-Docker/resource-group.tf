# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.user}-Intro-to-Docker"
  location = "${var.location}"
}
