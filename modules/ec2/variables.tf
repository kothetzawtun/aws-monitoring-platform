variable "name_prefix" {
  type        = string
  description = "Name prefix for EC2 resources."
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the monitoring EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups attached to the EC2 instance."
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name."
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name."
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
  description = "Domain name."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}
