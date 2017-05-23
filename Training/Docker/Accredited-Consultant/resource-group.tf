# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.user}-docker-accredited-consultant"
  location = "${var.location}"
}
