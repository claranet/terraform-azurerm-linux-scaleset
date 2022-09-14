locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  vmss_name     = coalesce(var.custom_vmss_name, azurecaf_name.vmss_linux.result)
  nic_name      = coalesce(var.custom_nic_name, azurecaf_name.nic.result)
  ipconfig_name = coalesce(var.custom_ipconfig_name, azurecaf_name.ipconfig.result)
  dcr_name      = coalesce(var.custom_dcr_name, format("dcra-%s", azurerm_linux_virtual_machine_scale_set.linux_vmss.name))
}
