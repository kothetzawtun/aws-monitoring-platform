terraform {
  backend "s3" {
    bucket       = "song-terraform-state-file"
    key          = "monitor/dev/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
