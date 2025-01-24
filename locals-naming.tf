locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  name                  = coalesce(var.custom_name, data.azurecaf_name.vmss_linux.result)
  nic_name              = coalesce(var.nic_custom_name, data.azurecaf_name.nic.result)
  ip_configuration_name = coalesce(var.ip_configuration_custom_name, data.azurecaf_name.ip_configuration.result)
  dcr_name              = coalesce(var.dcr_custom_name, format("dcra-%s", azurerm_linux_virtual_machine_scale_set.main.name))
}
