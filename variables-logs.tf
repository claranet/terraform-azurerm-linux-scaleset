variable "log_analytics_workspace_guid" {
  description = "GUID of the Log Analytics Workspace to link with"
  type        = string
  default     = null
}

variable "log_analytics_workspace_key" {
  description = "Access key of the Log Analytics Workspace to link with"
  type        = string
  default     = null
}

variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection"
  type        = string
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version"
  type        = string
  default     = "1.12"
}

variable "log_analytics_agent_enabled" {
  description = "Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux)"
  type        = bool
  default     = true
}

variable "log_analytics_agent_version" {
  description = "Azure Log Analytics extension version"
  type        = string
  default     = "1.13"
}

