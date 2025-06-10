# InfrastructureProject

This project implements a fully automated cloud-based infrastructure using **OpenTofu** and **Ansible** to provision and configure resources on AWS. It’s designed to be secure, scalable, and fully managed using Infrastructure as Code (IaC).

---

## 👥 Collaboration Note

This project was developed as part of a team during our DevOps course. We collaborated closely on all aspects — infrastructure provisioning, automation, and application deployment. All team members, including myself, contributed equally and worked together on every part of the project. 


## 🔍 Project Background

We were given a situation that our team has been hired as consultants to design and deliver a scalable infrastructure for a client’s web service. The client expects a secure solution deployed and maintained via automation.

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
   chmod +x install.sh
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
Once the script finishes and the app is deployed, open EC2 in AWS -> Load Balancers -> Copy Load Balancer DNS name -> Open in web browser:

📁 Project Structure

```txt
    InfrastructureProject/
    ├── Ansible/
    │   ├── app_setup.yml
    │   ├── inventory
    │   ├── postgres_setup.yml
    │   ├── python_setup.yml
    │   └── files/
    │       └── app.py
    ├── OpenTofu/
    │   ├── main.tf
    │   ├── output.tf
    │   ├── terraform.tfvars
    │   └── variable.tf
    ├── install.sh
    └── README.md
```
