module "linux_scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  vm_size        = "Standard_F4s_v2"
  admin_username = "myusername"

  subnet = module.subnet

  ssh_public_key = var.ssh_public_key

  ultra_ssd_enabled = true

  # Value depends on `var.vm_size` local storage size
  os_disk_size_gb = 31

  data_disks = [
    {
      lun                  = 0
      disk_size_gb         = 32
      caching              = "ReadOnly"
      storage_account_type = "Premium_LRS"
    },
    {
      lun                  = 1
      disk_size_gb         = 48
      disk_iops_read_write = 4000
      storage_account_type = "UltraSSD_LRS"
    },
  ]

  # The feature must be activated upstream:
  # az feature register --namespace Microsoft.Compute --name EncryptionAtHost --subscription <subscription_id_or_name>
  encryption_at_host_enabled = true

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  upgrade_mode = "Automatic"
  automatic_instance_repair = {
    enabled = true
  }

  load_balancer_backend_address_pool_ids = var.lb_backend_address_pool_id[*]
  health_probe = {
    id = var.health_probe_id
  }

  diagnostics_storage_account_name = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule = {
    id = module.run.data_collection_rule_id
  }

  extra_tags = {
    "extra-tag" = "extra-tag-value"
  }
}
