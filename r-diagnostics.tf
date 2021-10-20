resource "azurerm_virtual_machine_scale_set_extension" "azure_monitor_agent" {
  name = "${azurerm_linux_virtual_machine_scale_set.linux_vmss.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"

  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
}

resource "null_resource" "azure_monitor_link" {
  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${data.azurerm_client_config.current.subscription_id} \
              --method PUT \
              --url https://management.azure.com${azurerm_linux_virtual_machine_scale_set.linux_vmss.id}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${azurerm_linux_virtual_machine_scale_set.linux_vmss.name}-dcrassociation?api-version=2019-11-01-preview \
              --body '{"properties":{"dataCollectionRuleId": "${var.azure_monitor_data_collection_rule_id}"}}'
EOC
  }

  triggers = {
    dcr_id  = var.azure_monitor_data_collection_rule_id
    vmss_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
  }
}
