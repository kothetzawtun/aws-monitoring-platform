module "naming" {
  source = "../../modules/naming"

  org         = var.org
  project     = var.project
  environment = var.environment
  owner       = var.owner
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

module "iam" {
  source = "../../modules/iam"

  name_prefix     = module.naming.name_prefix
  aws_region      = var.aws_region
  environment     = var.environment
  config_bucket   = var.config_bucket
  github_org_repo = var.github_org_repo
}

module "security" {
  source = "../../modules/security"

  name_prefix       = module.naming.name_prefix
  vpc_id            = var.vpc_id
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}

module "ec2" {
  source = "../../modules/ec2"

  name_prefix           = module.naming.name_prefix
  ami_id                = data.aws_ami.al2023.id
  instance_type         = var.instance_type
  subnet_id             = var.public_subnet_id
  security_group_ids    = [module.security.ec2_sg_id]
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name
  root_volume_size      = var.root_volume_size
  data_volume_size      = var.data_volume_size
  domain_name           = var.domain_name
  environment           = var.environment
  aws_region            = var.aws_region
}

module "eip" {
  source = "../../modules/eip"

  name_prefix = module.naming.name_prefix
}

resource "aws_eip_association" "this" {
  instance_id   = module.ec2.instance_id
  allocation_id = module.eip.allocation_id
}

module "backup" {
  source = "../../modules/backup"

  name_prefix    = module.naming.name_prefix
  retention_days = var.backup_retention_days
}
