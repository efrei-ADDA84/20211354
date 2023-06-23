resource   "azurerm_public_ip"   "myvm1publicip"   {
  name   =   "devops-20211354"
  location   =   var.resource_group_location
  resource_group_name   =  var.resource_group_name_prefix
  allocation_method   =   "Dynamic"
  sku   =   "Basic"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "packages: ['docker.io']"
  }
}

data "azurerm_subnet" "example" {
  name = "internal"
  virtual_network_name = "network-tp4"
  resource_group_name = var.resource_group_name_prefix
}

resource   "azurerm_network_interface"   "myvm1nic"   {
  name   =   "myvm1-nic"
  location   =   var.resource_group_location
  resource_group_name   =   var.resource_group_name_prefix

  ip_configuration {
    name = data.azurerm_subnet.example.name
    subnet_id = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myvm1publicip.id
  }

}

resource "tls_private_key" "rsa_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource   "azurerm_linux_virtual_machine"   "example" {
  name = "devops-20211354"
  location = var.resource_group_location
  resource_group_name = "ADDA84-CTP"
  network_interface_ids = [
    azurerm_network_interface.myvm1nic.id]
  size = "Standard_D2s_v3"

  os_disk {
    name = "ubuntu-linux"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }

  custom_data = data.template_cloudinit_config.config.rendered

  admin_username = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.rsa_ssh.public_key_openssh
  }
}

