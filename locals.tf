locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  vmss_name     = coalesce(var.custom_vmss_name, "${local.default_name}-vmss")
  nic_name      = coalesce(var.custom_nic_name, "${local.default_name}-nic")
  ipconfig_name = coalesce(var.custom_ipconfig_name, "${local.default_name}-ipconfig")
}