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
3. Add the public key to GitHub

4. View the key:

```sh
    cat ~/.ssh/InfraProj-cocloudshell-key.pub
```
5. Then go to GitHub → ⚙️ Settings → SSH and GPG keys → New SSH key and paste it.

6. Start SSH agent and add your key:

```sh
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/InfraProj-cocloudshell-key
```    
7. Clone the repository using SSH:

```sh
    git clone git@github.com:<your-username>/<your-repo>.git
    cd <your-repo>
```
8. Run the script
```sh
    ./install.sh
```
🔧 What the Script Does
The install.sh script automates:

Installing OpenTofu and running:

tofu init
tofu apply -auto-approve
Generating or using an existing SSH key:

ssh-keygen -t rsa -b 4096 -C "aws-instance" -f ~/.ssh/InfraProj-cocloudshell-key -N ""
Updating terraform.tfvars with your current IP:

curl -s ifconfig.me
Updating Ansible inventory using Terraform outputs:

tofu output -raw public_Ec2_instance_public_ip
tofu output -raw public_Ec2_instance2_public_ip
tofu output -raw private_Ec2_instance_private_ip
Replacing IPs in the inventory and playbooks:

sed -i ...
Installing Ansible:

sudo dnf update -y
sudo dnf install -y ansible
Running playbooks to configure servers:

ansible-playbook -i inventory python_setup.yml
ansible-playbook -i inventory postgres_setup.yml
ansible-playbook -i inventory app_setup.yml

9. Accessing the Application
Once the script finishes and the app is deployed, open:
```sh
    http://<EC2_PUBLIC_IP>:5000/
```
📁 Project Structure

```txt
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
```