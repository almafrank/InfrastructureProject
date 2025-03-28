# InfrastructureProject

This project implements a fully automated cloud-based infrastructure using **OpenTofu** and **Ansible** to provision and configure resources on AWS. It’s designed to be secure, scalable, and fully managed using Infrastructure as Code (IaC).

---

## 🔍 Project Background

Your team has been hired as consultants to design and deliver a scalable infrastructure for a client’s web service. The client expects a secure solution deployed and maintained via automation.

---

## 🛠️ Tools Used

- **OpenTofu** – Infrastructure as Code tool to provision AWS resources
- **Ansible** – Configuration management and app deployment
- **AWS CloudShell** – Used to run everything directly in AWS

---

## 🚀 How to Deploy the Project

### ✅ Requirements

- AWS account (with CloudShell access)
- GitHub account (for SSH key setup)

---

### 📦 Deployment Steps

1. **Open CloudShell from AWS Console**

2. **Create an SSH key** (if not already created):
   ```sh
   ssh-keygen -t rsa -b 4096 -C "aws-instance" -f ~/.ssh/InfraProj-cocloudshell-key -N ""
Add the public key to GitHub

View the key:

sh
Copy
Edit
cat ~/.ssh/InfraProj-cocloudshell-key.pub
Then go to GitHub → ⚙️ Settings → SSH and GPG keys → New SSH key and paste it.

Start SSH agent and add your key:

sh
Copy
Edit
eval $(ssh-agent -s)
ssh-add ~/.ssh/InfraProj-cocloudshell-key
Clone the repository using SSH:

sh
Copy
Edit
git clone git@github.com:<your-username>/<your-repo>.git
cd <your-repo>
Make the install script executable and run it:

sh
Copy
Edit
cd Shell-Scripts
chmod +x install.sh
./install.sh
🔧 What the Script Does
The install.sh script automates:

Installing OpenTofu and running:

sh
Copy
Edit
tofu init
tofu apply -auto-approve
Generating or using an existing SSH key:

sh
Copy
Edit
ssh-keygen -t rsa -b 4096 -C "aws-instance" -f ~/.ssh/InfraProj-cocloudshell-key -N ""
Updating terraform.tfvars with your current IP:

sh
Copy
Edit
curl -s ifconfig.me
Updating Ansible inventory using Terraform outputs:

sh
Copy
Edit
tofu output -raw public_Ec2_instance_public_ip
tofu output -raw public_Ec2_instance2_public_ip
tofu output -raw private_Ec2_instance_private_ip
Replacing IPs in the inventory and playbooks:

sh
Copy
Edit
sed -i ...
Installing Ansible:

sh
Copy
Edit
sudo dnf update -y
sudo dnf install -y ansible
Running playbooks to configure servers:

sh
Copy
Edit
ansible-playbook -i inventory python_setup.yml
ansible-playbook -i inventory postgres_setup.yml
ansible-playbook -i inventory app_setup.yml
📁 Project Structure
css
Copy
Edit
InfrastructureProject/
├── Ansible/
│   ├── inventory
│   ├── python_setup.yml
│   ├── postgres_setup.yml
│   └── app_setup.yml
├── OpenTofu/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── Shell-Scripts/
│   └── install.sh
├── app.py
└── README.md
🌐 Accessing the Application
Once the script finishes and the app is deployed, open:

sh
Copy
Edit
http://<EC2_PUBLIC_IP>:5000/