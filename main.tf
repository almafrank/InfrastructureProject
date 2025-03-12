terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Skapa en nyckelpar i AWS baserat på en existerande nyckel (för SSH)
resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Skapa en EC2-instans
resource "aws_instance" "webserver" {
  key_name        = aws_key_pair.deployer_key.key_name
  count         = var.instance_count  # This will create multiple instances
  ami           = var.ami_id# Replace with your valid AMI ID
  instance_type = var.instance_type  # Choose your instance type

  vpc_security_group_ids = [aws_security_group.web_sg]

  tags = {
    Name = "OpenTofu-WebServer"
  }
}

# Skapa en säkerhetsgrupp för att tillåta SSH och HTTP
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web server"
  
  # Conditionally add SSH ingress rules for each trusted IP
  dynamic "ingress" {
    for_each = var.trusted_ips_for_ssh
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value] # Append /32 to each IP
    }
  }

  # Conditionally add HTTP ingress rules
dynamic "ingress" {
  for_each = length(var.restrict_ips_for_http) > 0 ? var.restrict_ips_for_http : ["0.0.0.0/0"]
  content {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ingress.value]
  }
}
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Tillåter all trafik ut från EC2-instansen
  }
}