resource "azurerm_availability_set" "ucp-as" {
  name                = "ucp-as"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_public_ip" "ucp-publicip" {
  name                         = "ucp-${count.index}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "cap-${var.user}-ucp-${count.index}"
  tags {
    environment = "${var.environment}"
  }
  count = "${var.ucp_count}"
}

resource "azurerm_network_interface" "ucp-networkinterface" {
  name                = "ucp-${count.index}-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  ip_configuration {
    name                          = "ucp-${count.index}-ni-ip"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
	public_ip_address_id          = "${element(azurerm_public_ip.ucp-publicip.*.id,count.index)}"
  }
  count = "${var.ucp_count}"
}

resource "azurerm_virtual_machine" "ucp-vm" {
  name                  = "ucp-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.ucp-networkinterface.*.id,count.index)}"]
  availability_set_id   = "${azurerm_availability_set.ucp-as.id}"
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "ucp-${count.index}-os-disk"
    vhd_uri       = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/ucp-${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  os_profile {
    computer_name  = "ucp-${count.index}"
    admin_username = "docker"
    admin_password = "${var.password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "${var.environment}"
  }
  provisioner "remote-exec" {
    connection {
	  type     = "ssh"
	  host     = "${element(azurerm_public_ip.ucp-publicip.*.domain_name_label,count.index)}.${var.location}.cloudapp.azure.com"
	  user     = "docker"
	  password = "${var.password}"
	}
    inline = [
      "sudo apt-get -y install apt-transport-https ca-certificates curl",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "curl -fsSL https://storebits.docker.com/ee/linux/sub-0fc42e50-bfbc-4e66-8789-841113d6130d/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://storebits.docker.com/ee/linux/sub-0fc42e50-bfbc-4e66-8789-841113d6130d/ubuntu $(lsb_release -cs) test\"",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ee",
	  "sudo groupadd docker",
	  "sudo usermod -aG docker docker"
    ]
  }
  count = "${var.ucp_count}"
}
