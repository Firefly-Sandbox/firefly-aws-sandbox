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

# resource "aws_s3_bucket_policy" "firefly-sandbox-s3" {
#   bucket = "${aws_s3_bucket.firefly-sandbox-s3.id}"
#   policy = jsonencode({
#   "Statement": [
#     {
#       "Action": "s3:GetObject",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Resource": "${aws_s3_bucket.firefly-sandbox-s3.arn}/*",
#       "Sid": "PublicReadGetObject"
#     }
#   ],
#   "Version": "2012-10-17"
# })
# }

# resource "aws_s3_bucket_acl" "firefly-sandbox-s3" {
#   access_control_policy {
#     grant {
#       grantee {
#         type = "Group"
#         uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
#       }
#       permission = "READ_ACP"
#     }
#     grant {
#       grantee {
#         type = "Group"
#         uri  = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
#       }
#       permission = "READ_ACP"
#     }
#     grant {
#       grantee {
#         type = "Group"
#         uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
#       }
#       permission = "READ_ACP"
#     }
#     grant {
#       grantee {
#         id   = "7db6dd8ef499c1b71362e5a8bad83bfd483878ec0f8b965f90686ac84980acdb"
#         type = "CanonicalUser"
#       }
#       permission = "FULL_CONTROL"
#     }
#     owner {
#       display_name = "daquinox+AWSGeneral"
#       id           = "7db6dd8ef499c1b71362e5a8bad83bfd483878ec0f8b965f90686ac84980acdb"
#     }
#   }
#   bucket = "${aws_s3_bucket.firefly-sandbox-s3.id}"
# }



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

