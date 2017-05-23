resource "azurerm_public_ip" "node-publicip" {
  name                         = "node-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "cap-${var.user}-itd-node"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_network_interface" "node-networkinterface" {
  name                = "node-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "node-ni-ip"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
	public_ip_address_id          = "${azurerm_public_ip.node-publicip.id}"
  }
}

resource "azurerm_virtual_machine" "node-vm" {
  name                  = "node"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.node-networkinterface.id}"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "node-os-disk"
    vhd_uri       = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/node.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "node"
    admin_username = "docker"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "${var.environment}"
  }

# Install Docker CE.
  provisioner "remote-exec" {
  
    connection {
	  type     = "ssh"
	  host     = "${azurerm_public_ip.node-publicip.domain_name_label}.${var.location}.cloudapp.azure.com"
	  user     = "docker"
	  password = "${var.password}"
	}
	
  }
}
