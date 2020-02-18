resource "azurerm_resource_group" "PunchCard" {
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
  name 					= "PunchCard-VNet"
  address_space 		= ["${var.vnet_cidr}"]
  location 				= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.PunchCard.name}"
  
  tags = "${var.tags}"
}

resource "azurerm_subnet" "pc_subnet_1" {
  name 					        = "PC-Subnet-1"
  address_prefix 		    = "${var.subnet1_cidr}"
  virtual_network_name 	= "${azurerm_virtual_network.pc_vnet.name}"
  resource_group_name 	= "${azurerm_resource_group.PunchCard.name}"
  service_endpoints     = ["Microsoft.Sql"]
}

resource "azurerm_public_ip" "pc_pubip" {
  name                         = "PunchCard-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.PunchCard.name}"
  allocation_method            = "Static"
  domain_name_label            = "${random_string.pc_fqdn.result}"

  tags = "${var.tags}"
}

resource "azurerm_network_interface" "public_nic" {
  name 		                  = "PunchCard-Web"
  location 	                = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.PunchCard.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_web.id}"

  ip_configuration {
    name 			                    = "PC-WebPrivate"
    subnet_id 			              = "${azurerm_subnet.pc_subnet_1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id	        = "${azurerm_public_ip.pc_pubip.id}"
  }
}

resource "azurerm_network_security_group" "nsg_web" {
  name 					= "PunchCard-NSG"
  location 				= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.PunchCard.name}"

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
	name 						= "AllowHTTP"
	priority					= 200
	direction					= "Inbound"
	access 						= "Allow"
	protocol 					= "Tcp"
	source_port_range          	= "*"
    destination_port_range     	= "80"
    source_address_prefix      	= "Internet"
    destination_address_prefix 	= "*"
  }

  security_rule {
	name 						= "AllowHTTPS"
	priority					= 300
	direction					= "Inbound"
	access 						= "Allow"
	protocol 					= "Tcp"
	source_port_range          	= "*"
    destination_port_range     	= "443"
    source_address_prefix      	= "Internet"
    destination_address_prefix 	= "*"
  }

  tags = "${var.tags}"
}
