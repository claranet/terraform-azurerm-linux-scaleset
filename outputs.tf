output "resource" {
  description = "Scale Set resource object."
  value       = azurerm_linux_virtual_machine_scale_set.main
}

output "id" {
  description = "Scale Set ID."
  value       = azurerm_linux_virtual_machine_scale_set.main.id
}

output "name" {
  description = "Scale Set name."
  value       = azurerm_linux_virtual_machine_scale_set.main.name
}

output "admin_username" {
  description = "Scale Set admin username."
  value       = azurerm_linux_virtual_machine_scale_set.main.admin_username
}

output "admin_password" {
  description = "Scale Set admin password."
  value       = azurerm_linux_virtual_machine_scale_set.main.admin_password
  sensitive   = true
}

output "admin_ssh_public_key" {
  description = "Scale Set admin SSH public key."
  value       = one(azurerm_linux_virtual_machine_scale_set.main.admin_ssh_key[*].public_key)
}

output "admin_ssh_private_key" {
  description = "Scale Set admin SSH private key."
  value       = var.ssh_private_key
  sensitive   = true
}

output "identity_principal_id" {
  description = "Object ID of the Scale Set Managed Service Identity."
  value       = one(azurerm_linux_virtual_machine_scale_set.main.identity[*].principal_id)
}
