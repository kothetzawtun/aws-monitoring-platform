locals {
  name_prefix = "${var.org}-${var.project}-${var.environment}"

  common_tags = {
    Organization = var.org
    Project      = var.project
    Environment  = var.environment
    Owner        = var.owner
    Managed_By   = "terraform"
  }
}
