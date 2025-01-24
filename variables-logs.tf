variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which Scale Set boot diagnostics are stored."
  type        = string
  default     = null
}

variable "azure_monitor_agent_enabled" {
  description = "Whether to enable Azure Monitor Agent. Requires a Data Collection Rule ID."
  type        = bool
  default     = true
  nullable    = false
}

variable "azure_monitor_data_collection_rule" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection."
  type = object({
    id = string
  })
  default = null
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version."
  type        = string
  default     = "1.22"
  nullable    = false
}
