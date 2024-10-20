#!/bin/bash

#this script works except the line: vault policy write jenkins /home/ubuntu/jenkins-policy.hcl

# Update and install Docker
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Run SonarQube container
# sudo docker run -d -p 9000:9000 --name sonarqube -v sonarqube
sudo docker volume create sonarqube-volume
sudo docker volume inspect volume sonarqube-volume
sudo docker run -d --name sonarqube -v sonarqube-volume:/opt/sonarqube/data -p 9000:9000 sonarqube:lts-community

# Wait for SonarQube to be fully up (adjust time as needed)
sleep 60

# Update and install necessary packages
sudo apt update
sudo apt install -y snapd wget unzip

# Install Vault
sudo snap install vault
vault --version

# # Create configuration directories and file
# sudo mkdir -p /etc/vault.d
# sudo touch /etc/vault.d/vault.hcl

# # Configuration for development mode (Modify as needed for production)
# cat <<EOF | sudo tee /etc/vault.d/vault.hcl
# storage "file" {
#   path = "/vault/data"
# }

# listener "tcp" {
#   address     = "0.0.0.0:8200"
#   tls_disable = 1
# }

# api_addr = "http://127.0.0.1:8200"
# disable_mlock = true
# ui = true
# EOF

# # Create Vault user and group
# sudo groupadd -r vault || true
# sudo useradd -r -g vault -s /sbin/nologin vault || true

# # Download Vault binary and move it to the correct location
# wget -q https://releases.hashicorp.com/vault/1.11.3/vault_1.11.3_linux_amd64.zip
# unzip -q vault_1.11.3_linux_amd64.zip
# sudo mv vault /usr/bin/vault
# sudo chmod +x /usr/bin/vault

# # Create systemd service file
# cat <<EOF | sudo tee /etc/systemd/system/vault.service
# [Unit]
# Description=HashiCorp Vault
# Documentation=https://www.vaultproject.io/docs
# After=network-online.target
# Wants=network-online.target

# [Service]
# ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
# Restart=on-failure
# User=vault
# Group=vault
# LimitNOFILE=65536
# CapabilityBoundingSet=CAP_IPC_LOCK CAP_SYSLOG
# ProtectSystem=full
# ProtectHome=yes
# NoNewPrivileges=true

# [Install]
# WantedBy=multi-user.target
# EOF

# # Set permissions
# sudo chown vault:vault /usr/bin/vault
# sudo chown -R vault:vault /etc/vault.d
# sudo mkdir -p /vault/data
# sudo chown -R vault:vault /vault/data

# # Set permissions for /home/ubuntu
# sudo chmod 755 /home/ubuntu

# # Reload systemd and start the Vault service
# sudo systemctl daemon-reload
# sudo systemctl start vault
# sudo systemctl enable vault

# # Wait for Vault to be up and running
# sleep 5

# # Initialize Vault and capture the output
# export VAULT_ADDR='http://127.0.0.1:8200'
# vault operator init | tee /home/ubuntu/init_output.txt

# # Extract unseal keys and root token from the output
# UNSEAL_KEYS=($(grep 'Unseal Key' /home/ubuntu/init_output.txt | awk '{print $4}'))
# ROOT_TOKEN=$(grep 'Initial Root Token' /home/ubuntu/init_output.txt | awk '{print $4}')

# # Unseal Vault
# echo "Unsealing Vault..."
# for i in {0..2}; do
#   echo "Unsealing with key ${UNSEAL_KEYS[$i]}..."
#   vault operator unseal ${UNSEAL_KEYS[$i]}
# done

# # Log in to Vault
# echo "Logging into Vault with root token..."
# vault login $ROOT_TOKEN

# # Enable KV secrets engine
# vault secrets enable -path=secrets kv

# # Store credentials in Vault
# vault write secrets/creds/docker username=abcd password=xyz

# # Create Jenkins policy file
# cat <<EOF | sudo tee /home/ubuntu/jenkins-policy.hcl
# path "secrets/creds/*" {
#   capabilities = ["read"]
# }
# EOF

# # Create a policy in Vault
# vault policy write jenkins /home/ubuntu/jenkins-policy.hcl

# # Enable AppRole authentication
# vault auth enable approle

# # Create the Jenkins role
# vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"

# # Output role_id and secret_id to a file
# ROLE_ID=$(vault read -field=role_id auth/approle/role/jenkins-role/role-id)
# SECRET_ID=$(vault write -f auth/approle/role/jenkins-role/secret-id | grep '^secret_id' | awk '{print $2}')

# cat <<EOF | sudo tee /home/ubuntu/approle_credentials.txt
# Role ID: $ROLE_ID
# Secret ID: $SECRET_ID
# EOF

# # Display the final status
# vault status

# # Print location of the init output and credentials file
# echo "Vault has been initialized and configured."
# echo "Please review the output file at /home/ubuntu/init_output.txt for the unseal tokens and initial root token."
# echo "Jenkins policy has been created and the AppRole credentials have been set up."
# echo "Role ID and Secret ID have been saved to /home/ubuntu/approle_credentials.txt."
