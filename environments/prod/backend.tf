terraform {
  backend "s3" {
    bucket       = "demo-terraform-state"
    key          = "monitoring/prod/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
