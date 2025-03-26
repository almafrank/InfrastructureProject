#!/bin/bash

# CLoudShell saves the files you have created but not installed packages and software
# so you may need to run this after being inactive on CloudShell

#Install tofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method standalone --skip-verify
rm install-opentofu.sh

tofu init

SSH_KEY_PATH="$HOME/.ssh/InfraProj-cloudshell-key" # ÄNDRA BEROENDE PÅ VAD DEN SKA HETA LOL

if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "🔑 Generating a new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -C "aws-instance" -f "$SSH_KEY_PATH" -N "" -q
    chmod 600 "$SSH_KEY_PATH"
    echo "✅ SSH key generated at $SSH_KEY_PATH"
else
    echo "🔑 SSH key already exists at $SSH_KEY_PATH"
fi



#Correct trusted ips for ssh connection
my_ip=$(curl -s ifconfig.me)

if [[ -z "$my_ip" ]]; then
    echo "Failed to fetch IP. Exiting..."
    exit 1
fi

sed -i "2s/.*/trusted_ips_for_ssh = [\"$my_ip\/32\"]/" terraform.tfvars

#Apply tofu
tofu apply -auto-approve



#Install Ansible
sudo dnf update -y
sudo dnf install -y ansible

#Correct inventory ip 
WEB1_PUBLIC_IP=$(tofu output -raw public_Ec2_instance_public_ip 2>/dev/null)
WEB2_PUBLIC_IP=$(tofu output -raw public_Ec2_instance2_public_ip 2>/dev/null)
DB_PRIVATE_IP=$(tofu output -raw private_Ec2_instance_private_ip 2>/dev/null)

if [[ -z "$WEB1_PUBLIC_IP" || -z "$WEB2_PUBLIC_IP" || -z "$DB_PRIVATE_IP" ]]; then
    echo "Error: One or more Terraform outputs are empty. Ensure Terraform is initialized and state is accessible."
    exit 1
fi

INVENTORY_FILE="inventory.ini"

sed -i "s/\(ec2-web1 ansible_host=\)[0-9.]\+/\1$WEB1_PUBLIC_IP/" "$INVENTORY_FILE"
sed -i "s/\(ec2-web2 ansible_host=\)[0-9.]\+/\1$WEB2_PUBLIC_IP/" "$INVENTORY_FILE"
sed -i "s/\(ec2-database ansible_host=\)[0-9.]\+/\1$DB_PRIVATE_IP/" "$INVENTORY_FILE"
sed -i "s/\(ansible_ssh_common_args='-o ProxyJump=ec2-user@\)[0-9.]\+/\1$WEB1_PUBLIC_IP/" "$INVENTORY_FILE"

echo "Ansible inventory file updated successfully!"

ansible-playbook -i inventory python_setup.yml
ansible-playbook -i inventory postgres_setup.yml
ansible-playbook -i inventory app_setup.yml
