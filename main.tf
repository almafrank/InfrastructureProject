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

# 1.Create vpc
resource "aws_vpc" "TestVPC" {
  cidr_block = "10.0.0.0/16"
  
    tags = {
        Name = "TestVPC"
    }
}