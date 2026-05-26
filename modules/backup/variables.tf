variable "name_prefix" {
  type        = string
  description = "Name prefix for resources."
}

variable "retention_days" {
  type        = number
  description = "Number of snapshots to retain."
  default     = 7
}
