variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection"
  type        = string
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version"
  type        = string
  default     = "1.22"
}
