# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Beta-${var.user}-docker"
  location = "${var.location}"
}
