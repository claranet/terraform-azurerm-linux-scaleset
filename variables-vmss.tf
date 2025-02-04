variable "vm_size" {
  description = "Size (SKU) of instances in the Scale Set."
  type        = string
  nullable    = false
}

variable "instance_count" {
  description = "Number of instances in the Scale Set. Defaults to `2`."
  type        = number
  default     = 2
  nullable    = false
}

variable "admin_username" {
  description = "Username of the Scale Set administrator account."
  type        = string
  nullable    = false
}

variable "admin_password" {
  description = "Password for the Scale Set administrator account. One of either `var.admin_password` or `var.ssh_public_key` must be specified. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "Public SSH key to be deployed on instances in the Scale set. One of either `var.admin_password` or `var.ssh_public_key` must be specified. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "Private SSH key to be deployed on instances in the Scale set."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "List of DNS servers."
  type        = list(string)
  default     = null
}

variable "ip_forwarding_enabled" {
  description = "Does this network interface support IP forwarding? Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "accelerated_networking_enabled" {
  description = "Should accelerated networking be enabled? Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "network_security_group" {
  description = "ID of the Network Security Group to be assigned to this network interface."
  type = object({
    id = string
  })
  default = null
}

variable "subnet" {
  description = "ID of the Subnet."
  type = object({
    id = string
  })
  nullable = false
}

variable "application_gateway_backend_address_pool_ids" {
  description = "List of references to backend address pools of an Application Gateway. A Scale Set can reference backend address pools of a single Application Gateway."
  type        = list(string)
  default     = null
}

variable "load_balancer_backend_address_pool_ids" {
  description = "List of references to backend address pools of Load Balancers. A Scale Set can reference backend address pools of one public and one internal Load Balancer."
  type        = list(string)
  default     = null
}

variable "load_balancer_inbound_nat_rules_ids" {
  description = "List of references to inbound NAT rules for Load Balancers."
  type        = list(string)
  default     = null
}

variable "application_security_group_ids" {
  description = "IDs of Application Security Groups (up to 20)."
  type        = list(string)
  default     = null
}

variable "encryption_at_host_enabled" {
  description = "Should all disks (including the temporary disk) attached to instances in the Scale Set be encrypted by enabling Encryption at Host? See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes) for list of compatible VM sizes. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "vtpm_enabled" {
  description = "Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Scale Set. Defaults to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = true
  nullable    = false
}

variable "ultra_ssd_enabled" {
  description = "Should the capacity to use `UltraSSD_LRS` Storage Account type be supported on this Scale Set?. Defaults to `false`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
  nullable    = false
}

variable "os_ephemeral_disk_enabled" {
  description = "Whether OS disk is local ephemeral disk. See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks). Changing this forces a new resource to be created."
  type        = bool
  default     = true
  nullable    = false
}

variable "os_ephemeral_disk_placement" {
  description = "Placement for the local ephemeral disk. Possibles values are `CacheDisk` and `ResourceDisk`. See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks). Defaults to `ResourceDisk`. Changing this forces a new resource to be created."
  type        = string
  default     = "ResourceDisk"
  nullable    = false

  validation {
    condition     = contains(["CacheDisk", "ResourceDisk"], var.os_ephemeral_disk_placement)
    error_message = "`var.os_ephemeral_disk_placement` must be one of 'CacheDisk' or 'ResourceDisk'."
  }
}

variable "os_disk_caching" {
  description = "OS disk caching requirements. Possible values are `None`, `ReadOnly` and `ReadWrite`. Defaults to `None`."
  type        = string
  default     = "None"
  nullable    = false

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "`var.os_disk_caching` must be one of 'None', 'ReadOnly' or 'ReadWrite'."
  }
}

variable "os_disk_managed_disk_type" {
  description = "Type of managed disk to create. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. Defaults to `StandardSSD_LRS`."
  type        = string
  default     = "StandardSSD_LRS"
  nullable    = false

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_managed_disk_type)
    error_message = "`var.os_disk_managed_disk_type` must be one of 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS', 'StandardSSD_ZRS' or 'Premium_ZRS'."
  }
}

variable "os_disk_encryption_set_id" {
  description = "ID of the Disk Encryption Set which should be used to encrypt the OS disk. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB."
  type        = number
  default     = 32
  nullable    = false
}

variable "os_disk_write_accelerator_enabled" {
  description = "Whether to enable write accelerator for the OS disk."
  type        = bool
  default     = false
  nullable    = false
}

variable "data_disks" {
  description = "Definition of data disks to be attached to instances in the Scale Set."
  type = list(object({
    # name                    = string (unexpected status 400 (400 Bad Request) with error: InvalidParameter: Parameter 'dataDisk.name' is not allowed.)
    lun                       = number
    disk_size_gb              = number
    create_option             = optional(string, "Empty")
    caching                   = optional(string, "None")
    storage_account_type      = optional(string, "StandardSSD_LRS")
    disk_encryption_set_id    = optional(string)
    disk_iops_read_write      = optional(string)
    disk_mbps_read_write      = optional(string)
    write_accelerator_enabled = optional(bool, false)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["Empty", "FromImage"], disk.create_option)
    ])
    error_message = "`var.data_disks[*].create_option` must be one of 'Empty' or 'FromImage'."
  }
  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["None", "ReadOnly", "ReadWrite"], disk.caching)
    ])
    error_message = "`var.data_disks[*].caching` must be one of 'None', 'ReadOnly' or 'ReadWrite'."
  }
  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "PremiumV2_LRS", "UltraSSD_LRS", "StandardSSD_ZRS", "Premium_ZRS"], disk.storage_account_type)
    ])
    error_message = "`var.data_disks[*].storage_account_type` must be one of 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS', 'PremiumV2_LRS', 'UltraSSD_LRS', 'StandardSSD_ZRS' or 'Premium_ZRS'."
  }
}

variable "source_image_id" {
  description = "ID of the source image to use. One of either `var.source_image_id` or `var.source_image_reference` must be specified. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "source_image_reference" {
  description = "Reference of the source image to use. One of either `var.source_image_id` or `var.source_image_reference` must be specified. Changing this forces a new resource to be created."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "upgrade_mode" {
  description = "Specifies how upgrades (e.g. changing the image/SKU) should be performed to instances in the Scale Set. Possible values are `Automatic`, `Manual` and `Rolling`. Defaults to `Manual`. Changing this forces a new resource to be created."
  type        = string
  default     = "Manual"
  nullable    = false

  validation {
    condition     = contains(["Automatic", "Manual", "Rolling"], var.upgrade_mode)
    error_message = "`var.upgrade_mode` must be one of 'Automatic', 'Manual' or 'Rolling'."
  }
}

variable "health_probe" {
  description = "Specifies the identifier for the Load Balancer health probe. Required when `var.upgrade_mode = \"Automatic\" or \"Rolling\"`."
  type = object({
    id = string
  })
  default = null
}

variable "automatic_rollback_enabled" {
  description = "Should automatic rollbacks be enabled? Only available when `var.upgrade_mode` is not 'Manual'. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "automatic_os_upgrade_enabled" {
  description = "Should OS upgrades automatically be applied to Scale Set instances in a rolling fashion when a newer version of the OS image becomes available? This is particularly useful when `var.upgrade_mode = \"Rolling\"`. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

# BUG: this variable cannot be updated via Terraform after the first deployment; this must be done via the Azure portal by disabling then re-enabling the feature with the updated parameters
# You can still fix the drift after your change by updating the values according to the new state
variable "automatic_instance_repair" {
  description = "Whether to enable automatic instance repair. Must have a valid `var.health_probe.id` or an [Application Health Extension](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension?tabs=rest-api)."
  type = object({
    enabled      = optional(bool, false)
    grace_period = optional(string, "PT10M")
    action       = optional(string, "Replace")
  })
  default  = {}
  nullable = false

  validation {
    condition     = var.automatic_instance_repair.enabled == false || (var.automatic_instance_repair.enabled && contains(["Replace", "Restart", "Reimage"], var.automatic_instance_repair.action))
    error_message = "`var.automatic_instance_repair.action` must be one of 'Replace', 'Restart' or 'Reimage'."
  }
}

variable "overprovisioning_enabled" {
  description = "Should Azure overprovision instances in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first, which improves provisioning success rates and improves deployment time. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "rolling_upgrade_policy" {
  description = "Rolling upgrade policy. Only applicable when `var.upgrade_mode` is not 'Manual'."
  type = object({
    cross_zone_upgrades_enabled             = optional(bool)
    max_batch_instance_percent              = optional(number, 25)
    max_unhealthy_instance_percent          = optional(number, 25)
    max_unhealthy_upgraded_instance_percent = optional(number, 25)
    pause_time_between_batches              = optional(string, "PT30S")
    prioritize_unhealthy_instances_enabled  = optional(bool)
    maximum_surge_instances_enabled         = optional(bool)
  })
  default  = {}
  nullable = false
}

variable "scale_in_policy" {
  description = "The scale-in policy rule that decides which instances are chosen for removal when a Virtual Machine Scale Set is scaled-in. Possible values are `Default`, `NewestVM` and `OldestVM`. Defaults to `Default`."
  type        = string
  default     = "Default"
  nullable    = false

  validation {
    condition     = contains(["Default", "NewestVM", "OldestVM"], var.scale_in_policy)
    error_message = "`var.scale_in_policy` must be one of 'Default', 'NewestVM' or 'OldestVM'."
  }
}

variable "scale_in_force_deletion_enabled" {
  description = "Whether the instances chosen for removal should be force deleted when the Virtual Machine Scale Set is being scaled-in."
  type        = bool
  default     = false
  nullable    = false
}

variable "identity" {
  description = "Identity block information as described in this [documentation](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity)."
  type = object({
    type         = optional(string, "SystemAssigned")
    identity_ids = optional(list(string))
  })
  default = {}

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], try(var.identity.type, "SystemAssigned"))
    error_message = "`var.identity.type` must be one of 'SystemAssigned', 'UserAssigned' or 'SystemAssigned, UserAssigned'."
  }
}

variable "extensions" {
  description = "Extensions to add to the Scale Set."
  type = list(object({
    name                        = string
    publisher                   = string
    type                        = string
    type_handler_version        = string
    auto_upgrade_minor_version  = optional(bool, true)
    automatic_upgrade_enabled   = optional(bool, false)
    failure_suppression_enabled = optional(bool, false)
    force_update_tag            = optional(string)
    protected_settings          = optional(string)
    provision_after_extensions  = optional(list(string))
    settings                    = optional(string)
  }))
  default  = []
  nullable = false
}

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set."
  type        = string
  default     = null
}

variable "zone_balancing_enabled" {
  description = "Whether the instances in this Scale Set should be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created."
  type        = bool
  default     = true
  nullable    = false
}

variable "zones" {
  description = "A list of Availability Zones in which the instances in this Scale Set should be created in. Updating zones to remove an existing zone forces a new resource to be created."
  type        = list(number)
  default     = [1, 2, 3]
  nullable    = false
}
