# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_vmss_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_vmss_name" {
  description = "Custom name for the Virtual Machine ScaleSet"
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
