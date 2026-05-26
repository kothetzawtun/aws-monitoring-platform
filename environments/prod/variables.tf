variable "org" {
  type        = string
  description = "Organization name used in resource naming and tags."
}

variable "project" {
  type        = string
  description = "Project name used in resource naming and tags."
}

variable "environment" {
  type        = string
  description = "Environment name such as dev or prod."
}

variable "owner" {
  type        = string
  description = "Owner tag value."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID."
}

variable "public_subnet_id" {
  type        = string
  description = "Existing public subnet ID for the monitoring EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name for emergency SSH access."
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access SSH."
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GB."
}

variable "data_volume_size" {
  type        = number
  description = "Data EBS volume size in GB."
}

variable "domain_name" {
  type        = string
  description = "External DNS name for the monitoring platform."
}

variable "backup_retention_days" {
  type        = number
  description = "Number of daily EBS snapshots to retain."
  default     = 7
}

variable "config_bucket" {
  type        = string
  description = "S3 bucket used by GitHub Actions to upload config.zip."
}

variable "github_org_repo" {
  type        = string
  description = "GitHub repository in org/repo format, used for OIDC trust policy."
}
