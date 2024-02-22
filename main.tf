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


resource "aws_s3_bucket" "firefly-sandbox-s3" {
  bucket = "firefly-sandbox-s3-${random_string.UUID.result}"
  tags = {
    purpose = "firefly-sandbox"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "firefly-sandbox-s3" {
  bucket = "${aws_s3_bucket.firefly-sandbox-s3.id}"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "firefly-sandbox-s3" {
  bucket = "${aws_s3_bucket.firefly-sandbox-s3.id}"
}

resource "aws_s3_bucket_ownership_controls" "firefly-sandbox-s3" {
  bucket = "${aws_s3_bucket.firefly-sandbox-s3.id}"
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_dynamodb_table" "firefly-sandbox-dynamodb" {
  attribute {
    name = "firefly-metadata"
    type = "S"
  }
  hash_key       = "firefly-metadata"
  name           = "firefly-sandbox-dynamodb"
  read_capacity  = 1
  stream_enabled = false
  tags = {
    purpose = "firefly-sandbox"
  }
  write_capacity = 1
}

resource "aws_lambda_function" "firefly-sandbox-lambda" {
  architectures = ["x86_64"]
  description   = "A starter AWS Lambda function."
  function_name = "firefly-sandbox-lambda"
  handler       = "index.handler"
  //role          = "arn:aws:iam::821020995254:role/firefly-sandbox-lamdba-role"
  role          = "${aws_iam_role.firefly-sandbox-lamdba-role.arn}"
  runtime       = "nodejs18.x"
  s3_bucket     = "firefly-lambda-zipstor"
  s3_key        = "firefly-demo-lambda.zip"
  tags = {
    "lambda-console:blueprint" = "hello-world"
    purpose                    = "firefly-sandbox"
  }
  tracing_config {
    mode = "PassThrough"
  }
  # The following attributes have default values introduced when importing the resource into terraform: [publish timeouts]
  lifecycle {
    ignore_changes = [publish, timeouts]
  }
}

resource "aws_iam_role" "firefly-sandbox-lamdba-role" {
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
  name                = "firefly-sandbox-lamdba-role"
  tags = {
    purpose = "firefly-sandbox"
  }
}

resource "aws_security_group" "firefly-sandbox-drift" {
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
  name = "firefly-sandbox-drift"
  tags = {
    Name    = "firefly-sandbox-drift"
    purpose = "firefly-sandbox"
  }
  vpc_id = "vpc-037dc00595a0092f8"
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}

resource "aws_security_group" "firefly-sandbox-ghost" {
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
  name = "firefly-sandbox-ghost"
  tags = {
    Name    = "firefly-sandbox-ghost"
    purpose = "firefly-sandbox"
  }
  vpc_id = "vpc-037dc00595a0092f8"
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}


resource "aws_iam_role" "GItHubActions-782" {
  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::590184073875:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:Firefly-Sandbox/*"
        }
      }
    }
  ]
})
  inline_policy {
    name   = "TerraformLockAccess"
    policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:ListTabless",
        "dynamodb:DeleteItem"
      ],
      "Resource": "*"
    }
  ]
})
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  name   = var.iam_role_use_name_prefix ? null : var.iam_role_name   # e.g. GItHubActions
  tags = merge(var.tags, var.iam_role_tags)
}


resource "aws_vpc" "Fargate-Internal-217" {
  cidr_block                     = var.use_ipam_pool ? null : var.cidr   # e.g. 10.0.0.0/24
  enable_classiclink_dns_support = false
  tags = merge(
    var.tags,
    var.vpc_tags,
  )
}


resource "aws_default_network_acl" "acl-07198e3a534db93dc-8de" {
  default_network_acl_id = "acl-07198e3a534db93dc"
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }
  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }
}


resource "aws_route_table" "rtb-064898d79749b3008-b34" {
  vpc_id = "${aws_vpc.vpc-060c03b3f03576a62.id}"
}


resource "aws_iam_role" "AmazonEKSFargatePodExecutionRole-e00" {
  assume_role_policy  = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks-fargate-pods.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:eks:us-east-1:590184073875:fargateprofile/Firefly-Sandbox-EKS/*"
        }
      }
    }
  ]
})
  description         = var.iam_role_description   # e.g. Allows access to other AWS service resources that are required to run Amazon EKS pods on AWS Fargate.
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]
  name                = var.iam_role_use_name_prefix-e00d ? null : var.iam_role_name-e00d   # e.g. AmazonEKSFargatePodExecutionRole
  tags = merge(var.tags, var.iam_role_tags)
}


resource "aws_vpc" "firefly-sandbox-vpc-02f" {
  cidr_block                     = var.use_ipam_pool-02f0 ? null : var.cidr-02f   # e.g. 10.0.0.0/24
  enable_classiclink_dns_support = false
  tags = merge(
    var.tags,
    var.vpc_tags,
  )
}


resource "aws_route_table" "rtb-0dc6d472eaf87747b-dec" {
  vpc_id = "${aws_vpc.vpc-037dc00595a0092f8.id}"
}


resource "aws_default_network_acl" "acl-0ea4c444fb06f0516-86d" {
  default_network_acl_id = "acl-0ea4c444fb06f0516"
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }
  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }
}

