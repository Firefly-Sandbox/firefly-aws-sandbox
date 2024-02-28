# The code was generated for this provider version (it can be changed to your preference). 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "acme-prod-vpc-572" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name    = "acme-prod-vpc"
    purpose = "acme-prod"
  }
}

