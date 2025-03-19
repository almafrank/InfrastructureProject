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

# 1.Create  1 vpc
resource "aws_vpc" "TestVPC" {
  cidr_block = "10.0.0.0/16"
  
    tags = {
        Name = "TestVPC"
    }
}

#4.Create a public Subnet
resource "aws_subnet" "subnet-1-public"{
    vpc_id = aws_vpc.TestVPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "SubNet 1 public"
  }
}

#2.Create Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.TestVPC.id
  tags = {
    Name = "Test InternetGataway"
  }

}

#3.Create Custom Route Table
resource "aws_route_table" "test-route-table-public" {
  vpc_id = aws_vpc.TestVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 
  tags = {
    Name = "Test Route table public"
  }
}
#Assoication
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet-1-public.id
  route_table_id = aws_route_table.test-route-table-public.id
}


#data "aws_ami" "amazon_linux" {
#  most_recent = true
#  owners      = ["amazon"]
#  filter {
#    name   = "name"
#    values = ["al2023-ami-*"]
#  }
#}

# Skapa en nyckelpar i AWS baserat på en existerande nyckel (för SSH)
resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

#
resource "aws_instance" "public_Ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet-1-public.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.public_ec2_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public Webserver 1"
  }
}

#
resource "aws_security_group" "private_ec2_security_group" {
  name        = "private_ec2_security_group"
  vpc_id      = aws_vpc.TestVPC.id

  ingress {
    description = "Allow PostgreSQL from public EC2 instances"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups =  [aws_security_group.public_ec2_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Tillåter all trafik ut från EC2-instansen
  }
}

resource "aws_instance" "public_Ec2_instance2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet-1-public.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.public_ec2_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public Webserver 2"
  }
}

#
resource "aws_security_group" "public_ec2_security_group" {
  name        = "public_ec2_security_group"
  vpc_id      = aws_vpc.TestVPC.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.restrict_ips_for_http
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.trusted_ips_for_ssh
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

    tags = {
    Name = "allow_web"
  }
}

#För privata instanser och resurser
resource "aws_subnet" "subnet-2-private"{
    vpc_id = aws_vpc.TestVPC.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "SubNet 2 private"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.TestVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
  depends_on = [aws_nat_gateway.nat]
}

#declare vpc for nat gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}
#nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet-1-public.id

  depends_on = [aws_internet_gateway.gw]
}
#Create route table associations
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.subnet-2-private.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_instance" "private_Ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet-2-private.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.public_ec2_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public Webserver 1"
  }
}