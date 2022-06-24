output "scale_set_id" {
  description = "Scale Set ID"
  value       = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
}

output "scale_set_name" {
  description = "Scale Set Name"
  value       = azurerm_linux_virtual_machine_scale_set.linux_vmss.name
}

output "system_assigned_identity" {
  description = "Identity block with principal ID"
  value       = azurerm_linux_virtual_machine_scale_set.linux_vmss.identity
}

output "scale_set_admin_username" {
  description = "Scale Set admin username"
  value       = var.admin_username
  sensitive   = true
}

output "scale_set_admin_password" {
  description = "Scale Set admin password"
  value       = var.admin_password
  sensitive   = true
}

output "scale_set_admin_ssh_private_key" {
  description = "Scale Set admin SSH private key"
  value       = var.ssh_private_key
  sensitive   = true
}

output "scale_set_admin_ssh_public_key" {
  description = "Scale Set admin SSH public key"
  value       = var.ssh_public_key
  sensitive   = true
}
