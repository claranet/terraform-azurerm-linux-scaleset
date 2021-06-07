output "scale_set_id" {
  description = "Scale Set ID"
  value       = azurerm_linux_virtual_machine_scale_set.linux-vmss.0.id
}

output "scale_set_name" {
  description = "Scale Set Name"
  value       = azurerm_linux_virtual_machine_scale_set.linux-vmss.0.name
}

output "system_assigned_identity" {
  description = "Identity block with principal ID"
  value       = azurerm_linux_virtual_machine_scale_set.linux-vmss.0.identity
}
