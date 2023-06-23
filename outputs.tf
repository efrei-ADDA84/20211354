output "resource_group_name" {
  value = var.resource_group_name_prefix
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.rsa_ssh.private_key_pem
  sensitive = true

}