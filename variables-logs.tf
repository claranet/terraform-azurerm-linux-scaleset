variable "azure_monitor_data_collection_rule_enabled" {
  description = "`true` to enable Data Collection Rule ID"
  type        = bool
  default     = true
}

variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection"
  type        = string
  default     = ""
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version"
  type        = string
  default     = "1.22"
}
