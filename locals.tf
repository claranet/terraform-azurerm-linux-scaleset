locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  default_name = lower("${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  vmss_name     = coalesce(var.custom_vmss_name, "${local.default_name}-vmss")
  nic_name      = coalesce(var.custom_nic_name, "${local.default_name}-nic")
  ipconfig_name = coalesce(var.custom_ipconfig_name, "${local.default_name}-ipconfig")
}

