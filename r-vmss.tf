resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  instances           = var.instances_count
  location            = var.location
  name                = local.vmss_name
  resource_group_name = var.resource_group_name
  sku                 = var.vms_size

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
    name                          = local.nic_name
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_ip_forwarding          = var.ip_forwarding_enabled
    enable_accelerated_networking = var.accelerated_networking
    network_security_group_id     = var.network_security_group_id

    ip_configuration {
      name                                         = local.ipconfig_name
      primary                                      = true
      subnet_id                                    = var.subnet_id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
      load_balancer_backend_address_pool_ids       = var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids          = var.load_balancer_inbound_nat_rules_ids
      application_security_group_ids               = var.application_security_group_ids
    }
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_managed_disk_type
    dynamic "diff_disk_settings" {
      for_each = var.os_ephemeral_disk_enabled ? ["fake"] : []
      content {
        option = "Local"
      }
    }
    disk_encryption_set_id    = var.os_disk_encryption_set_id
    disk_size_gb              = var.os_disk_size_gb
    write_accelerator_enabled = var.os_disk_write_accelerator_enabled
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      name                           = data_disk.name
      caching                        = data_disk.caching
      create_option                  = data_disk.create_option
      disk_size_gb                   = data_disk.disk_size_gb
      lun                            = data_disk.lun
      storage_account_type           = data_disk.storage_account_type
      disk_encryption_set_id         = data_disk.disk_encryption_set_id
      ultra_ssd_disk_iops_read_write = data_disk.disk_iops_read_write
      ultra_ssd_disk_mbps_read_write = data_disk.disk_mbps_read_write
      write_accelerator_enabled      = data_disk.write_accelerator_enabled
    }
  }


  dynamic "automatic_os_upgrade_policy" {
    for_each = var.upgrade_mode == "Automatic" ? ["fake"] : []
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
  user_data       = var.user_data
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

  overprovision = var.overprovision

  scale_in {
    rule                   = var.scale_in_policy
    force_deletion_enabled = var.scale_in_force_deletion
  }

  lifecycle {
    ignore_changes = [instances]
  }

  dynamic "extension" {
    for_each = var.extensions
    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = extension.value.auto_upgrade_minor_version
      force_update_tag           = extension.value.force_update_tag
      protected_settings         = extension.value.protected_settings
      provision_after_extensions = extension.value.provision_after_extensions
      settings                   = extension.value.settings
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? ["fake"] : []
    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  upgrade_mode = var.upgrade_mode
  zone_balance = var.zone_balancing_enabled
  zones        = var.zones_list

  tags = merge(local.default_tags, var.extra_tags)
}
