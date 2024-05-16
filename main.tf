resource "azurerm_virtual_network" "example" {
  name                = "sai-example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "sai-internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "sai-example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
resource "azurerm_public_ip" "example" {
  name                = "sai-public-ip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "sai-example-resources"
  location = "West Europe"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "sai-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS2_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

    admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    command    = "echo ${azurerm_linux_virtual_machine.example.public_ip_address} > vmip.txt"
  }

    provisioner "file" {
    when        = create
    on_failure  = continue
    source      = "./test.sh"
    destination = "/tmp/test.sh"
  }
  provisioner "remote-exec" {
    when       = create
    on_failure = continue
    inline = [
      "chmod +x /tmp/test.sh",
      "/tmp/test.sh",
      "rm /tmp/test.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = self.admin_username
    private_key = file("id_rsa")
    host        = self.public_ip_address
  }
}
