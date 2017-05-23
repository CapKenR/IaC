resource "azurerm_public_ip" "lb1-publicip" {
  name                         = "lb-1-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "cap-${var.student}-dac-lb-1"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_network_interface" "lb1-networkinterface" {
  name                = "lb-1-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "lb-1-ni-ip"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
	public_ip_address_id          = "${azurerm_public_ip.lb1-publicip.id}"
  }
}

resource "azurerm_virtual_machine" "lb1-vm" {
  name                  = "lb-1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.lb1-networkinterface.id}"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "lb-1-os-disk"
    vhd_uri       = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/lb-1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "lb-1"
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
	  host     = "${azurerm_public_ip.lb1-publicip.domain_name_label}.${var.location}.cloudapp.azure.com"
	  user     = "docker"
	  password = "${var.password}"
	}
	
    inline = [
      "sudo apt-get -y install apt-transport-https ca-certificates curl",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ce",
	  "sudo groupadd docker",
	  "sudo usermod -aG docker docker"
    ]
  }
}
