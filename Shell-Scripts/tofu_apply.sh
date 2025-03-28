#!/bin/bash  

my_ip=$(curl -s ifconfig.me)

if [[ -z "$my_ip" ]]; then
    echo "Failed to fetch IP. Exiting..."
    exit 1
fi

sed -i "2s/.*/trusted_ips_for_ssh = [\"$my_ip\/32\"]/" terraform.tfvars

tofu apply
