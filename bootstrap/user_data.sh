#!/bin/bash
set -euxo pipefail

# Terraform template variables
DOMAIN_NAME="${domain_name}"
ENVIRONMENT="${environment}"
AWS_REGION="${aws_region}"

# System packages
dnf update -y
dnf install -y docker jq awscli openssl unzip

systemctl enable docker
systemctl start docker
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

usermod -aG docker ec2-user || true

# Docker Compose plugin
mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Directories
mkdir -p /opt/monitoring
mkdir -p /opt/ssl
mkdir -p /data/prometheus
mkdir -p /data/grafana
mkdir -p /data/alertmanager

# Data EBS volume
DEVICE="/dev/nvme1n1"

if [ -b "$DEVICE" ]; then
  if ! blkid "$DEVICE"; then
    mkfs -t xfs "$DEVICE"
  fi

  grep -q "$${DEVICE}" /etc/fstab || \
    echo "$${DEVICE} /data xfs defaults,nofail 0 2" >> /etc/fstab

  mount -a
fi

# Data directory ownership for containers
# Grafana runs as UID 472
# Prometheus and Alertmanager run as nobody (65534)
chown -R 472:472 /data/grafana
chmod 750 /data/grafana

chown -R 65534:65534 /data/prometheus
chmod 750 /data/prometheus

chown -R 65534:65534 /data/alertmanager
chmod 750 /data/alertmanager

# Grafana password from SSM Parameter Store
GRAFANA_ADMIN_PASSWORD=$(aws ssm get-parameter \
  --region "$AWS_REGION" \
  --name "/monitoring/$${ENVIRONMENT}/grafana/password" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text)

# Write environment file
echo "DOMAIN_NAME=$${DOMAIN_NAME}" > /opt/monitoring/.env
echo "GRAFANA_ADMIN_PASSWORD=$${GRAFANA_ADMIN_PASSWORD}" >> /opt/monitoring/.env

# Temporary self-signed SSL certificate
# Replace with real certificate after deployment
if [ ! -s /opt/ssl/fullchain.crt ] || [ ! -s /opt/ssl/privkey.pem ]; then
  openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
    -keyout /opt/ssl/privkey.pem \
    -out /opt/ssl/fullchain.crt \
    -subj "/CN=$${DOMAIN_NAME}"
fi

chmod 644 /opt/ssl/fullchain.crt
chmod 600 /opt/ssl/privkey.pem

# Start monitoring stack if config already exists
# First full deployment normally comes from GitHub Actions via SSM
if [ -f /opt/monitoring/config/docker-compose.yml ]; then
  docker compose -f /opt/monitoring/config/docker-compose.yml \
    --env-file /opt/monitoring/.env \
    up -d
fi