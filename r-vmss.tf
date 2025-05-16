resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  sku       = var.vm_size
  instances = var.instance_count

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.admin_password == null

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key[*]
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  network_interface {
    name                          = local.nic_name
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_ip_forwarding          = var.ip_forwarding_enabled
    enable_accelerated_networking = var.accelerated_networking_enabled
    network_security_group_id     = try(var.network_security_group.id, null)

    ip_configuration {
      name                                         = local.ip_configuration_name
      primary                                      = true
      subnet_id                                    = var.subnet.id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
      load_balancer_backend_address_pool_ids       = var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids          = var.load_balancer_inbound_nat_rules_ids
      application_security_group_ids               = var.application_security_group_ids
    }
  }

  encryption_at_host_enabled = var.encryption_at_host_enabled
  vtpm_enabled               = var.vtpm_enabled

  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? [0] : []
    content {
      ultra_ssd_enabled = true
    }
  }

  os_disk {
    caching                   = var.os_ephemeral_disk_enabled ? "ReadOnly" : var.os_disk_caching
    storage_account_type      = var.os_ephemeral_disk_enabled ? "Standard_LRS" : var.os_disk_managed_disk_type
    disk_encryption_set_id    = var.os_disk_encryption_set_id
    disk_size_gb              = var.os_disk_size_gb
    write_accelerator_enabled = !var.os_ephemeral_disk_enabled && contains(["None", "ReadOnly"], var.os_disk_caching) ? var.os_disk_write_accelerator_enabled : false

    dynamic "diff_disk_settings" {
      for_each = var.os_ephemeral_disk_enabled ? [0] : []
      content {
        option    = "Local"
        placement = var.os_ephemeral_disk_placement
      }
    }
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      # name                         = data_disk.value.name
      lun                            = data_disk.value.lun
      disk_size_gb                   = data_disk.value.disk_size_gb
      create_option                  = data_disk.value.create_option
      caching                        = data_disk.value.caching
      storage_account_type           = data_disk.value.storage_account_type
      disk_encryption_set_id         = data_disk.value.disk_encryption_set_id
      ultra_ssd_disk_iops_read_write = contains(["PremiumV2_LRS", "UltraSSD_LRS"], data_disk.value.storage_account_type) ? data_disk.value.disk_iops_read_write : null
      ultra_ssd_disk_mbps_read_write = contains(["PremiumV2_LRS", "UltraSSD_LRS"], data_disk.value.storage_account_type) ? data_disk.value.disk_mbps_read_write : null
      write_accelerator_enabled      = contains(["None", "ReadOnly"], data_disk.value.caching) ? data_disk.value.write_accelerator_enabled : false
    }
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? var.source_image_reference[*] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  upgrade_mode = var.upgrade_mode

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? [0] : []
    content {
      disable_automatic_rollback  = !var.automatic_rollback_enabled
      enable_automatic_os_upgrade = var.automatic_os_upgrade_enabled
    }
  }

  health_probe_id = try(var.health_probe.id, null)

  dynamic "automatic_instance_repair" {
    for_each = var.automatic_instance_repair.enabled ? var.automatic_instance_repair[*] : []
    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = automatic_instance_repair.value.grace_period
      action       = automatic_instance_repair.value.action
    }
  }

  overprovision = var.overprovisioning_enabled

  dynamic "rolling_upgrade_policy" {
    for_each = var.upgrade_mode != "Manual" ? var.rolling_upgrade_policy[*] : []
    content {
      cross_zone_upgrades_enabled             = rolling_upgrade_policy.value.cross_zone_upgrades_enabled
      max_batch_instance_percent              = rolling_upgrade_policy.value.max_batch_instance_percent
      max_unhealthy_instance_percent          = rolling_upgrade_policy.value.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = rolling_upgrade_policy.value.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = rolling_upgrade_policy.value.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = rolling_upgrade_policy.value.prioritize_unhealthy_instances_enabled
      maximum_surge_instances_enabled         = !var.overprovisioning_enabled ? rolling_upgrade_policy.value.maximum_surge_instances_enabled : null
    }
  }

  scale_in {
    rule                   = var.scale_in_policy
    force_deletion_enabled = var.scale_in_force_deletion_enabled
  }

  dynamic "identity" {
    for_each = var.identity[*]
    content {
      type         = identity.value.type
      identity_ids = endswith(var.identity.type, "UserAssigned") ? identity.value.identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.diagnostics_storage_account_name[*]
    content {
      storage_account_uri = "https://${boot_diagnostics.value}.blob.core.windows.net"
    }
  }

  custom_data = var.custom_data
  user_data   = var.user_data

  zone_balance = var.zone_balancing_enabled
  zones        = var.zone_balancing_enabled ? var.zones : null

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    precondition {
      condition     = var.admin_password != null || var.ssh_public_key != null
      error_message = "One of either `var.admin_password` or `var.ssh_public_key` must be specified."
    }
    precondition {
      condition     = var.source_image_id != null || var.source_image_reference != null
      error_message = "One of either `var.source_image_id` or `var.source_image_reference` must be specified."
    }
    precondition {
      condition     = contains(["Automatic", "Rolling"], var.upgrade_mode) ? var.health_probe != null : true
      error_message = "A valid `var.health_probe.id` must be specified when `var.upgrade_mode` is set to 'Automatic' or 'Rolling'."
    }
    precondition {
      condition     = anytrue([for type in var.data_disks[*].storage_account_type : type == "UltraSSD_LRS"]) ? var.ultra_ssd_enabled : true
      error_message = "To use Ultra Disk, you must set `var.ultra_ssd_enabled = true`."
    }

    ignore_changes = [
      instances,
      tags["__AzureDevOpsElasticPool"],
      tags["__AzureDevOpsElasticPoolTimeStamp"],
    ]
  }
}

moved {
  from = azurerm_linux_virtual_machine_scale_set.linux_vmss
  to   = azurerm_linux_virtual_machine_scale_set.main
}
