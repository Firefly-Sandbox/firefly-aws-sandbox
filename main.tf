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

resource "random_string" "UUID" {
  length  = 10
  special = false
  upper   = false
  numeric  = true
  lower   = true
}


resource "aws_s3_bucket" "acme-prod-s3" {
  bucket = "acme-prod-s3-${random_string.UUID.result}"
  tags = {
    purpose = "acme-prod"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "acme-prod-s3" {
  bucket = "${aws_s3_bucket.acme-prod-s3.id}"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "acme-prod-s3" {
  bucket = "${aws_s3_bucket.acme-prod-s3.id}"
}

resource "aws_s3_bucket_ownership_controls" "acme-prod-s3" {
  bucket = "${aws_s3_bucket.acme-prod-s3.id}"
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_dynamodb_table" "acme-prod-dynamodb" {
  attribute {
    name = "acme-metadata"
    type = "S"
  }
  hash_key       = "acme-metadata"
  name           = "acme-prod-dynamodb"
  read_capacity  = 1
  stream_enabled = false
  tags = {
    purpose = "acme-prod"
  }
  write_capacity = 2
}

resource "aws_lambda_function" "acme-prod-lambda" {
  architectures = ["x86_64"]
  description   = "A starter AWS Lambda function."
  function_name = "acme-prod-lambda"
  handler       = "index.handler"
  //role          = "arn:aws:iam::821020995254:role/acme-prod-lamdba-role"
  role          = "${aws_iam_role.acme-prod-lamdba-role.arn}"
  runtime       = "nodejs14.x"
  s3_bucket     = "firefly-lambda-zipstor"
  s3_key        = "firefly-demo-lambda.zip"
  tags = {
    "lambda-console:blueprint" = "hello-world"
    purpose                    = "acme-prod"
  }
  tracing_config {
    mode = "PassThrough"
  }
  # The following attributes have default values introduced when importing the resource into terraform: [publish timeouts]
  lifecycle {
    ignore_changes = [publish, timeouts]
  }
}

resource "aws_iam_role" "acme-prod-lamdba-role" {
  assume_role_policy  = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
})
  description         = "Allows Lambda functions to call AWS services on your behalf."
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  name                = "acme-prod-lamdba-role"
  tags = {
    purpose = "acme-prod"
  }
}

resource "aws_security_group" "acme-prod-drift" {
  description = "sandbox drifted resources"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  name = "acme-prod-drift"
  tags = {
    Name    = "acme-prod-drift"
    purpose = "acme-prod"
  }
  vpc_id = "vpc-0a9f81e0f33455180"
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}

resource "aws_security_group" "acme-prod-ghost" {
  description = "sandbox ghosted resources"
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
  name = "acme-prod-ghost"
  tags = {
    Name    = "acme-prod-ghost"
    purpose = "acme-prod"
  }
  vpc_id = "vpc-0a9f81e0f33455180"
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}

