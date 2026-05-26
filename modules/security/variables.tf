variable "name_prefix" {
  type        = string
  description = "Name prefix for resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access SSH."
}
