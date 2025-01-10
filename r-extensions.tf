resource "azurerm_virtual_machine_scale_set_extension" "main" {
  for_each = {
    for ext in var.extensions : ext.name => ext
  }

  name = each.key

  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.main.id

  settings           = each.value.settings
  protected_settings = each.value.protected_settings

  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled
  failure_suppression_enabled = each.value.failure_suppression_enabled
  provision_after_extensions  = each.value.provision_after_extensions
  force_update_tag            = each.value.force_update_tag

  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }
}

moved {
  from = azurerm_virtual_machine_scale_set_extension.extension
  to   = azurerm_virtual_machine_scale_set_extension.main
}
