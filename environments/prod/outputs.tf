output "elastic_ip" {
  value = module.eip.public_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "ssm_session" {
  value = "aws ssm start-session --target ${module.ec2.instance_id}"
}

output "grafana_password_parameter" {
  value = "/monitoring/${var.environment}/grafana/password"
}

output "github_deploy_role_arn" {
  value = module.iam.github_deploy_role_arn
}
