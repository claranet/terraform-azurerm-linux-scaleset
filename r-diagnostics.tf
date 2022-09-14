resource "azurerm_virtual_machine_scale_set_extension" "azure_monitor_agent" {
  name = "${azurerm_linux_virtual_machine_scale_set.linux_vmss.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
}

resource "azurerm_data_collection_rule_association" "azure_monitor" {
  name                    = "dcra-${azurerm_linux_virtual_machine_scale_set.linux_vmss.name}"
  target_resource_id      = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
  data_collection_rule_id = var.azure_monitor_data_collection_rule_id
}
