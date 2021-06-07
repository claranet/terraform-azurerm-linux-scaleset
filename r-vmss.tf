resource "azurerm_linux_virtual_machine_scale_set" "linux-vmss" {
  instances           = var.instances_count
  location            = var.location
  name                = local.vmss_name
  resource_group_name = var.resource_group_name
  sku                 = var.vms_sku

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.admin_password != null ? false : true

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? ["fake"] : []
    content {
      public_key = var.ssh_public_key
      username   = var.admin_username
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? ["fake"] : []
    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? ["fake"] : []
    content {
      type         = lookup(var.identity, "type")
      identity_ids = lookup(var.identity, "identity_ids", [])
    }
  }

  source_image_id = var.source_image_id

  network_interface {
    name    = local.nic_name
    primary = true

    ip_configuration {
      name                                         = local.ipconfig_name
      primary                                      = true
      subnet_id                                    = var.subnet_id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
      load_balancer_backend_address_pool_ids       = var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids          = var.load_balancer_inbound_nat_rules_ids
    }
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_managed_disk_type
    dynamic "diff_disk_settings" {
      for_each = var.os_disk_is_local ? ["fake"] : []
      content {
        option = "Local"
      }
    }
    disk_encryption_set_id    = var.os_disk_encryption_set_id
    disk_size_gb              = var.os_disk_size_gb
    write_accelerator_enabled = var.os_disk_write_accelerator_enabled
  }

  dynamic "data_disk" {
    for_each = length(var.data_disks) != 0 ? var.data_disks : []
    content {
      caching                   = data_disk.caching
      create_option             = data_disk.create_option
      disk_size_gb              = data_disk.disk_size_gb
      lun                       = data_disk.lun
      storage_account_type      = data.storage_account_type
      disk_encryption_set_id    = lookup(data_disk, "disk_encryption_set_id", null)
      disk_iops_read_write      = lookup(data_disk, "disk_iops_read_write", null)
      disk_mbps_read_write      = lookup(data_disk, "disk_mbps_read_write", null)
      write_accelerator_enabled = lookup(data_disk, "write_accelerator_enabled", false)
    }
  }


  dynamic "automatic_os_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? ["fake"] : []
    content {
      disable_automatic_rollback  = var.disable_automatic_rollback
      enable_automatic_os_upgrade = var.automatic_os_upgrade
    }
  }

  automatic_instance_repair {
    enabled = var.automatic_instance_repair
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  custom_data     = var.custom_data
  health_probe_id = var.health_probe_id

  dynamic "rolling_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? ["fake"] : []
    content {
      max_batch_instance_percent              = lookup(var.rolling_upgrade_policy, "max_batch_instance_percent")
      max_unhealthy_instance_percent          = lookup(var.rolling_upgrade_policy, "max_unhealthy_instance_percent")
      max_unhealthy_upgraded_instance_percent = lookup(var.rolling_upgrade_policy, "max_unhealthy_upgraded_instance_percent")
      pause_time_between_batches              = lookup(var.rolling_upgrade_policy, "pause_time_between_batches")
    }
  }

  scale_in_policy = var.scale_in_policy

  lifecycle {
    ignore_changes = [instances]
  }

  dynamic "extension" {
    for_each = var.extensions != {} ? var.extensions : {}
    content {
      name                       = extension.key
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = lookup(extension.value, "auto_upgrade_minor_version", true)
      force_update_tag           = lookup(extension.value, "force_update_tag", null)
      protected_settings         = lookup(extension.value, "protected_settings", null)
      provision_after_extensions = lookup(extension.value, "provision_after_extensions", [])
      settings                   = lookup(extension.value, "settings", null)
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? ["fake"] : []
    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  upgrade_mode = var.upgrade_mode
  zone_balance = var.zone_balance
  zones        = var.zones_list

  tags = merge(local.default_tags, var.extra_tags)
}
