# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "custom_name" {
  description = "Custom name for the Virtual Machine Scale Sets. Generated if not set."
  type        = string
  default     = null
}

variable "nic_custom_name" {
  description = "Custom name for the network interfaces. Generated if not set."
  type        = string
  default     = null
}

variable "ip_configuration_custom_name" {
  description = "Custom name for the IP configuration of the network interfaces. Generated if not set."
  type        = string
  default     = null
}

variable "dcr_custom_name" {
  description = "Custom name for the Data Collection Rule association."
  type        = string
  default     = null
}
