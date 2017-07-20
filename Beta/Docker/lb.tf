resource "azurerm_public_ip" "ucp-lb-publicip" {
  name                         = "ucp-lb-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "cap-${var.user}-ucp-lb"
  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_lb" "ucp-lb" {
  name                = "ucp-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  frontend_ip_configuration {
    name                 = "ucp-lb-frontend"
    public_ip_address_id = "${azurerm_public_ip.ucp-lb-publicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "ucp-lb-backend" {
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.ucp-lb.id}"
  name                = "ucp-lb-backend"
}

resource "azurerm_public_ip" "dtr-lb-publicip" {
  name                         = "dtr-lb-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "cap-${var.user}-dtr-lb"
  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_lb" "dtr-lb" {
  name                = "dtr-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  frontend_ip_configuration {
    name                 = "dtr-lb-frontend"
    public_ip_address_id = "${azurerm_public_ip.dtr-lb-publicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "dtr-lb-backend" {
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.dtr-lb.id}"
  name                = "dtr-lb-backend"
}

resource "azurerm_public_ip" "worker-lb-publicip" {
  name                         = "worker-lb-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "cap-${var.user}-worker-lb"
  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_lb" "worker-lb" {
  name                = "worker-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  frontend_ip_configuration {
    name                 = "worker-lb-frontend"
    public_ip_address_id = "${azurerm_public_ip.worker-lb-publicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "worker-lb-backend" {
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.worker-lb.id}"
  name                = "worker-lb-backend"
}
