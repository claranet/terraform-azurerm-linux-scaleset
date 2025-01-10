data "azurecaf_name" "vmss_linux" {
  name          = var.stack
  resource_type = "azurerm_linux_virtual_machine_scale_set"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "nic" {
  name          = var.stack
  resource_type = "azurerm_network_interface"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "ip_configuration" {
  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = compact([local.name_prefix, "ipconfig"])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
