provider "aws" {
  region = "us-east-1"
}

resource "random_string" "UUID" {
  length  = 10
  special = false
  upper   = false
  numeric  = true
  lower   = true
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-${random_string.UUID.result}"
     
  lifecycle {
    prevent_destroy = true
  }
}

# resource "aws_security_group" "acme-prod-ghost" {}

resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = "tfstate-${random_string.UUID.result}"

    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_vpc" "acme-prod-vpc" {
  cidr_block                     = "10.0.0.0/24"
  tags = {
    Name    = "acme-prod-vpc"
    purpose = "acme-prod"
  }
}

resource "aws_security_group" "acme-prod-drift" {
  description = "prod drifted resources"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
  }
  name = "acme-prod-drift"
  tags = {
    Name    = "acme-prod-drift"
    purpose = "acme-prod"
  }
  vpc_id = aws_vpc.acme-prod-vpc.id
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}

output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
  description = "The name of the bucket"
}

output "acme_prod_vpc" {
  value = aws_vpc.acme-prod-vpc.id
  description = "Firefly Sandboc VPC ID"
}