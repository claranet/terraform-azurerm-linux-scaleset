variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region to use"
}

variable "location_short" {
  description = "Short string for Azure location"
}

variable "environment" {
  description = "Project environment"
}

variable "stack" {
  description = "Project stack name"
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "ssh_public_key" {
  description = "Path to the public SSH key deployed on Scale set"
  type        = string
  default     = null
}

variable "accelerated_networking" {
  description = "Specifies whether to enable accelerated networking or not"
  type        = string
  default     = "false"
}

variable "dns_settings" {
  description = "Specifies an array of dns servers"
  type        = list(string)
  default     = []
}

variable "ip_forwarding" {
  description = "Whether IP forwarding is enabled on this NIC"
  type        = string
  default     = "false"
}

variable "network_security_group_id" {
  description = "Specifies the identifier for the network security group"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Specifies the identifier of the subnet"
  type        = string
}

variable "application_gateway_backend_address_pool_ids" {
  description = "Specifies an array of references to backend address pools of application gateways. A scale set can reference backend address pools of one application gateway"
  type        = list(string)
  default     = []
}

variable "load_balancer_backend_address_pool_ids" {
  description = "Specifies an array of references to backend address pools of load balancers. A scale set can reference backend address pools of one public and one internal load balancer"
  type        = list(string)
  default     = []
}

variable "load_balancer_inbound_nat_rules_ids" {
  description = "Specifies an array of references to inbound NAT rules for load balancers"
  type        = list(string)
  default     = []
}

variable "application_security_group_ids" {
  description = "Specifies up to 20 application security group IDs"
  type        = list(string)
  default     = []
}

variable "public_ip_address_configuration" {
  description = "Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration"
  type        = list(string)
  default     = []
}

variable "vms_sku" {
  description = "Specifies the size of virtual machines in a scale set"
  type        = string
}

variable "os_disk_managed_disk_type" {
  description = "Specifies the type of managed disk to create [Possible values : Standard_LRS, StandardSSD_LRS or Premium_LRS]"
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements [Possible values : None, ReadOnly, ReadWrite]"
  type        = string
  default     = "None"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 32
}

variable "os_disk_is_local" {
  description = "Specifies the Ephemeral Disk Settings for the OS Disk to Local"
  type        = bool
  default     = false
}

variable "os_disk_encryption_set_id" {
  description = "The ID of the Disk Encryption Set which should be used to encrypt this Data Disk"
  type        = string
  default     = null
}

variable "os_disk_write_accelerator_enabled" {
  description = "hould Write Accelerator be enabled for this Data Disk?"
  type        = bool
  default     = false
}

variable "automatic_os_upgrade" {
  description = "Automatic OS patches can be applied by Azure to your scaleset. This is particularly useful when upgrade_policy_mode is set to Rolling."
  type        = bool
  default     = false
}

variable "disable_automatic_rollback" {
  description = "Disable automatic rollback in case of failured"
  type        = bool
  default     = false
}

variable "rolling_upgrade_policy" {
  description = "This is only applicable when the upgrade_policy_mode is Rolling."
  type = object({
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
  })
  default = {
    max_batch_instance_percent              = 25
    max_unhealthy_instance_percent          = 25
    max_unhealthy_upgraded_instance_percent = 25
    pause_time_between_batches              = "PT30S"
  }
}

variable "automatic_instance_repair" {
  description = "Enable automatic instance repair. Must have health_probe_id or an Application Health Extension"
  type        = bool
  default     = false
}

variable "health_probe_id" {
  description = "Specifies the identifier for the load balancer health probe. Required when using Rolling as your upgrade_policy_mode."
  type        = string
  default     = null
}

variable "boot_diagnostics_storage_uri" {
  description = "Blob endpoint for the storage account to hold the virtual machine's diagnostic files"
  type        = string
  default     = ""
}

variable "extensions" {
  description = "Can be specified to add extension profiles to the scale set"
  type        = map(any)
  default     = {}
}

variable "eviction_policy" {
  description = "Specifies the eviction policy for Virtual Machines in this Scale Set, eviction_policy can only be set when priority is set to Low [Possible values : Deallocate and Delete]"
  type        = string
  default     = "Deallocate"
}

variable "priority" {
  description = "Specifies the priority for the Virtual Machines in the Scale Set. [Possible values : Low and Regular]"
  type        = string
  default     = "Regular"
}

variable "data_disks" {
  description = "A storage profile data disk"
  type        = list(string)
  default     = []
}

variable "ultra_ssd_enabled" {
  description = "Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine Scale Set?"
  type        = bool
  default     = false
}

variable "extra_tags" {
  description = "Additional tags to associate with your network security group."
  type        = map(string)
  default     = {}
}

variable "admin_username" {
  description = "Username to use as admin user"
  type        = string
}

variable "admin_password" {
  description = "Password for the administrator account of the virtual machine."
  type        = string
  default     = null
}

variable "custom_vmss_name" {
  description = "Custom name for the Virtual Machine ScaleSet"
  type        = string
  default     = null
}

variable "instances_count" {
  description = "Specify the number of instances to run"
  type        = number
  default     = 1
}

variable "source_image_reference" {
  description = "Source Image references"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "source_image_id" {
  description = "Id of the image to use."
  type        = string
  default     = null
}

variable "custom_nic_name" {
  description = "Custom name for Network Interfaces"
  type        = string
  default     = null
}

variable "custom_ipconfig_name" {
  description = "Custom name for Ipconfiguration"
  type        = string
  default     = null
}

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set."
  type        = string
  default     = null
}

variable "scale_in_policy" {
  description = "The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default"
  type        = string
  default     = "Default"
}

variable "upgrade_mode" {
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual."
  type        = string
  default     = "Manual"
}

variable "zone_balance" {
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "zones_list" {
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in. Changing this forces a new resource to be created."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "os_type" {
  description = "OS type used with VMSS (linux or windows)"
  type        = string
  default     = "linux"
}

variable "identity" {
  description = "Map with identity block informations as described here https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity"
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}
