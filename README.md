# InfrastructureProject

This project implements a fully automated cloud-based infrastructure using **OpenTofu** and **Ansible** to provision and configure resources on AWS. It’s designed to be secure, scalable, and fully managed using Infrastructure as Code (IaC).

---

## 🔍 Project Background

Our team has been hired as consultants to design and deliver a scalable infrastructure for a client’s web service. The client expects a secure solution deployed and maintained via automation.

---

## 🛠️ Tools Used

- **AWS CloudShell** – Used to run everything directly in AWS
- **OpenTofu** – Infrastructure as Code tool to provision AWS resources
- **Ansible** – Configuration management and app deployment

---

## 🚀 How to Deploy the Project

### ✅ Requirements

- AWS account (with CloudShell access)
- GitHub account 

---

### 📦 Deployment Steps

1. **Open CloudShell from AWS Console**

2. **Create an SSH key** (if not already created):
   ```sh
   ssh-keygen -t rsa -b 4096 -C "aws-instance" -f ~/.ssh/InfraProj-cocloudshell-key -N ""
3. **Add the public key to GitHub**

- View the key:

```sh
    cat ~/.ssh/InfraProj-cocloudshell-key.pub
```
- Copy the key 
- Then go to GitHub → ⚙️ Settings → SSH and GPG keys → New SSH key and paste it.

4. **Start SSH agent and add your key**

```sh
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/InfraProj-cocloudshell-key
```    
5. **Clone the repository using SSH**

```sh
    git clone git@github.com:almafrank/InfrastructureProject.git
    cd InfrastructureProject
```
6. **Run the script**
```sh
    ./install.sh
```
🔧 **What the Script Does**
The install.sh script automates:

- Installing OpenTofu and running
- Generating or using an existing SSH key
- Updating terraform.tfvars with your current IP
- Updating Ansible inventory using Terraform outputs
- Replacing IPs in the inventory and playbooks
- Installing Ansible
- Running playbooks to configure servers

7. **Accessing the Application**
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