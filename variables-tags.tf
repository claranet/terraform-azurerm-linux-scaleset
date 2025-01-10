variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
  nullable    = false
}

variable "extra_tags" {
  description = "Additional tags to associate with the Scale Set."
  type        = map(string)
  default     = {}
  nullable    = false
}
