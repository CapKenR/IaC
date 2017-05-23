# Create a resource group.
resource "azurerm_resource_group" "resourcegroup" {
  name     = "Training-${var.student}-docker-accredited-consultant"
  location = "${var.location}"
}
