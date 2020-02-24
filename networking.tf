resource "azurerm_resource_group" "PunchClock" {
  name 		= "${var.resource_group_name}"
  location 	= "${var.location}"

  tags = "${var.tags}"
}

resource "random_string" "pc_fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

resource "azurerm_virtual_network" "pc_vnet" {
  name 					= "PunchClock-VNet"
  address_space 		= ["${var.vnet_cidr}"]
  location 				= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.PunchClock.name}"
  
  tags = "${var.tags}"
}

resource "azurerm_subnet" "pc_subnet" {
  name 					        = "PunchClock-Subnet"
  address_prefix 		    = "${var.subnet1_cidr}"
  virtual_network_name 	= "${azurerm_virtual_network.pc_vnet.name}"
  resource_group_name 	= "${azurerm_resource_group.PunchClock.name}"
  service_endpoints     = ["Microsoft.Sql"]
}

resource "azurerm_public_ip" "pc_pubip" {
  name                         = "PunchClock-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.PunchClock.name}"
  allocation_method            = "Static"
  domain_name_label            = "${random_string.pc_fqdn.result}"

  tags = "${var.tags}"
}

resource "azurerm_network_interface" "public_nic" {
  name 		                  = "PunchClock-Web"
  location 	                = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.PunchClock.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_web.id}"

  ip_configuration {
    name 			                    = "PC-WebPrivate"
    subnet_id 			              = "${azurerm_subnet.pc_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id	        = "${azurerm_public_ip.pc_pubip.id}"
  }
}

resource "azurerm_network_security_group" "nsg_web" {
  name 					= "PunchClock-NSG"
  location 				= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.PunchClock.name}"

  security_rule {
	name 						= "AllowSSH"
	priority 					= 100
	direction 					= "Inbound"
	access 						= "Allow"
	protocol 					= "Tcp"
	source_port_range          	= "*"
    destination_port_range     	= "22"
    source_address_prefix      	= "*"
    destination_address_prefix 	= "*"
  }

  security_rule {
	name 						= "AllowJs"
	priority					= 200
	direction					= "Inbound"
	access 						= "Allow"
	protocol 					= "Tcp"
	source_port_range          	= "*"
    destination_port_range     	= "3000"
    source_address_prefix      	= "Internet"
    destination_address_prefix 	= "*"
  }

  #security_rule {
	#name 						= "AllowDBaccess"
	#priority					= 300
	#direction					= "Inbound"
	#access 						= "Allow"
	#protocol 					= "Tcp"
	#source_port_range          	= "*"
  #  destination_port_range     	= "3306"
  #  source_address_prefix      	= "Internet"
  #  destination_address_prefix 	= "*"
  #}

  tags = "${var.tags}"
}
