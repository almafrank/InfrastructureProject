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

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Test Route table public"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet-1-public.id
  route_table_id = aws_route_table.test-route-table-public.id
}

