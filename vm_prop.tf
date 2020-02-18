resource "azurerm_virtual_machine" "PunchCard" {
  name                  = "PunchCard-VM"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.PunchCard.name}"
  network_interface_ids = ["${azurerm_network_interface.public_nic.id}"]
  vm_size               = "Standard_DS1_v2"

#This will delete the OS disk and data disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "pc-os-1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name           = "pc-data-1"  
    lun            = 0
    disk_size_gb   = "10"
    caching        = "ReadWrite"
    create_option  = "Empty"
  }

  os_profile {
    computer_name  = "punchcard"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = "${var.tags}"
}

resource "azurerm_virtual_machine_extension" "PunchCard" {
  name                  = "configuration"
  virtual_machine_id    = azurerm_virtual_machine.PunchCard.id
  publisher             = "Microsoft.Azure.Extensions"
  type                  = "CustomScript"
  type_handler_version  = "2.1"

  settings = <<SETTINGS
    {
        "skipDos2Unix":true,
        "fileUris": ["https://raw.githubusercontent.com/dirkreitz/PunchCard/master/setup.sh"],
        "commandToExecute": "bash setup.sh"
    }
SETTINGS

  tags = "${var.tags}"
}
