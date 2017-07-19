resource "azurerm_public_ip" "wnw-publicip" {
  name                         = "worker-win-${count.index}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "cap-${var.student}-worker-win-${count.index}"
  tags {
    environment = "${var.environment}"
  }
  count = "${var.wnw_count}"
}

resource "azurerm_network_interface" "wnw-networkinterface" {
  name                = "worker-win-${count.index}-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
  ip_configuration {
    name                          = "worker-win-${count.index}-ni-ip"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
	public_ip_address_id          = "${element(azurerm_public_ip.wnw-publicip.*.id,count.index)}"
	}
  count = "${var.wnw_count}"
}

resource "azurerm_virtual_machine" "wnw-vm" {
  name                  = "worker-win-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.wnw-networkinterface.*.id,count.index)}"]
  vm_size               = "Standard_A0"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name          = "worker-win-${count.index}-os-disk"
    vhd_uri       = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/worker-win-${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  os_profile {
    computer_name  = "worker-win-${count.index}"
    admin_username = "docker"
    admin_password = "${var.password}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }
  tags {
    environment = "${var.environment}"
  }
  count = "${var.wnw_count}"
}
