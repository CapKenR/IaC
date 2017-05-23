# Create a network security group.
resource "azurerm_network_security_group" "nsg" {
  name                = "docker-enterprise-operations-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  security_rule {
    name                       = "any-internal"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8000"
    priority                   = 2010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8001"
    priority                   = 2020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8002"
    priority                   = 2030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8002"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8080"
    priority                   = 2040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8081"
    priority                   = 2050
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "8082"
    priority                   = 2060
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8082"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment}"
  }
}

# Create a virtual network.
resource "azurerm_virtual_network" "network" {
  name                = "docker-enterprise-operations-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
}

# Create a subnet.
resource "azurerm_subnet" "subnet" {
  name                 = "docker-enterprise-operations-subnet"
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  address_prefix       = "10.0.1.0/24"
}
