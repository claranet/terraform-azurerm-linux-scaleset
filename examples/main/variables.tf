variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project Stack name."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH Public key to authorize on VMSS's instances."
  type        = string
}

variable "lb_backend_address_pool_id" {
  description = "ID of the Load Balancer backend address pool to use for the VMSS."
  type        = string
}

variable "health_probe_id" {
  description = "ID of the health probe to use for the VMSS."
  type        = string
}
