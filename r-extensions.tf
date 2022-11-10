resource "azurerm_virtual_machine_scale_set_extension" "extension" {
  for_each = { for ext in var.extensions : ext.name => ext }

  name = each.key

  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version

  settings           = each.value.settings
  protected_settings = each.value.protected_settings

  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled
  failure_suppression_enabled = each.value.failure_suppression_enabled
  force_update_tag            = each.value.force_update_tag
  provision_after_extensions  = each.value.provision_after_extensions

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
}
