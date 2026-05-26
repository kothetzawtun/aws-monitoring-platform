variable "name_prefix" {
  type        = string
  description = "Name prefix for IAM resources."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "config_bucket" {
  type        = string
  description = "S3 bucket used for config artifact transport."
}

variable "github_org_repo" {
  type        = string
  description = "GitHub repository in org/repo format."
}
