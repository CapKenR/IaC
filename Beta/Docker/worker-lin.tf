resource "azurerm_public_ip" "wnl-publicip" {
  name                         = "worker-lin-${count.index}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "cap-${var.user}-worker-lin-${count.index}"
  tags {
    environment = "${var.environment}"
  }
  count = "${var.wnl_count}"
}

resource "azurerm_network_interface" "wnl-networkinterface" {
  name                = "worker-lin-${count.index}-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  ip_configuration {
    name                          = "worker-lin-${count.index}-ni-ip"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
	public_ip_address_id          = "${element(azurerm_public_ip.wnl-publicip.*.id,count.index)}"
	}
  count = "${var.wnl_count}"
}

resource "azurerm_virtual_machine" "wnl-vm" {
  name                  = "worker-lin-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.wnl-networkinterface.*.id,count.index)}"]
  vm_size               = "Standard_A0"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "worker-lin-${count.index}-os-disk"
    vhd_uri       = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/worker-lin-${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  os_profile {
    computer_name  = "worker-lin-${count.index}"
    admin_username = "docker"
    admin_password = "${var.password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "${var.environment}"
  }
  count = "${var.wnl_count}"
}
