locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  vmss_name     = coalesce(var.custom_vmss_name, "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-vmss")
  nic_name      = coalesce(var.custom_nic_name, "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-nic")
  ipconfig_name = coalesce(var.custom_ipconfig_name, "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ipconfig")
}

