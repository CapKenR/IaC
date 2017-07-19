# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Beta-${var.student}-docker"
  location = "${var.location}"
}
