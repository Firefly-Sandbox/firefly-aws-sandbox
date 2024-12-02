resource "aws_eks_fargate_profile" "f6c6f355-6f84-c19f-b45a-10a4135a5ad2-e66" {
  cluster_name           = "acme-eks-prod"
  fargate_profile_name   = "fp-acme"
  pod_execution_role_arn = "arn:aws:iam::590184073875:role/eksctl-acme-eks-prod-cluste-FargatePodExecutionRole-sHpFO1GWtCwO"
  selector {
    namespace = "firefly"
  }
  selector {
    namespace = "newrelic"
  }
  subnet_ids = ["subnet-032ce0f510d034142", "subnet-0c577ed793762eea8"]
}


resource "aws_eks_fargate_profile" "_92c6f354-7269-8350-e5bc-fdf7f88ff9af-141" {
  cluster_name           = "acme-eks-prod"
  fargate_profile_name   = "fp-default"
  pod_execution_role_arn = "arn:aws:iam::590184073875:role/eksctl-acme-eks-prod-cluste-FargatePodExecutionRole-sHpFO1GWtCwO"
  selector {
    namespace = "default"
  }
  selector {
    namespace = "kube-system"
  }
  subnet_ids = ["subnet-032ce0f510d034142", "subnet-0c577ed793762eea8"]
}


resource "aws_vpc" "acme-prod-vpc-572" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name    = "acme-prod-vpc"
    purpose = "acme-prod"
  }
}


resource "aws_route_table" "Kubernetes-Fargate-3d5" {
  tags = {
    Name  = "Kubernetes-Fargate"
    owner = "Robert"
  }
  vpc_id = "vpc-0f3358e78c0cb9a7f"
}


resource "aws_vpc" "Fargate-Internal-217" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name    = "Fargate-Internal"
    owner   = "Robert"
    purpose = "firefly-sandbox"
  }
}


resource "aws_s3_bucket" "tfstate-od3tuznbuq-eeb" {
  bucket = "tfstate-od3tuznbuq"
}


resource "aws_dynamodb_table" "app-state-44e" {
  attribute {
    name = "LockID"
    type = "S"
  }
  hash_key       = "LockID"
  name           = "app-state"
  read_capacity  = 1
  stream_enabled = false
  write_capacity = 1
}


resource "aws_security_group" "Kubernetes-b45" {
  description = "Minikube access"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = ["24.107.166.218/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  name = "Kubernetes"
  tags = {
    Name  = "Kubernetes"
    owner = "Robert"
  }
  vpc_id = "vpc-0f3358e78c0cb9a7f"
  # The following attributes have default values introduced when importing the resource into terraform: [revoke_rules_on_delete timeouts]
  lifecycle {
    ignore_changes = [revoke_rules_on_delete, timeouts]
  }
}


resource "aws_vpc" "Kubernetes-6f9" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name  = "Kubernetes"
    owner = "Robert"
  }
}


resource "aws_key_pair" "robert-firefly-eeb" {
  key_name   = "robert-firefly"
  public_key = "PUT-VALUE-HERE"
  # The following attributes are sensitive values redacted by Firefly and should be replaced with your own: [public_key]
  lifecycle {
    ignore_changes = [public_key]
  }
}


resource "aws_kms_alias" "aliasfirefly-event-tracking-40a" {
  name          = "alias/firefly-event-tracking"
  target_key_id = "cd7a1400-e02c-4541-b46d-7b4128463af5"
}


resource "aws_cloudtrail" "management-events-832" {
  advanced_event_selector {
    field_selector {
      equals = ["Management"]
      field  = "eventCategory"
    }
    name = "Management events selector"
  }
  enable_log_file_validation    = true
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  kms_key_id                    = "arn:aws:kms:us-east-1:590184073875:key/cd7a1400-e02c-4541-b46d-7b4128463af5"
  name                          = "management-events"
  s3_bucket_name                = "aws-cloudtrail-logs-590184073875-4fc539c7"
}


resource "aws_kms_key" "cd7a1400-e02c-4541-b46d-7b4128463af5-d1a" {
  description = "The key created by CloudTrail to encrypt log files. Created Tue Feb 13 17:26:32 UTC 2024"
  policy      = jsonencode({
  "Id": "Key policy created by CloudTrail",
  "Statement": [
    {
      "Action": "kms:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::590184073875:root",
          "arn:aws:sts::590184073875:assumed-role/AWSReservedSSO_AdministratorAccessFull_bd13fd2ff6fef8e0/robert@firefly.ai"
        ]
      },
      "Resource": "*",
      "Sid": "Enable IAM User Permissions"
    },
    {
      "Action": "kms:GenerateDataKey*",
      "Condition": {
        "StringEquals": {
          "aws:SourceArn": "arn:aws:cloudtrail:us-east-1:590184073875:trail/management-events"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:590184073875:trail/*"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "*",
      "Sid": "Allow CloudTrail to encrypt logs"
    },
    {
      "Action": "kms:DescribeKey",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "*",
      "Sid": "Allow CloudTrail to describe key"
    },
    {
      "Action": [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ],
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "590184073875"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:590184073875:trail/*"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "*",
      "Sid": "Allow principals in the account to decrypt log files"
    },
    {
      "Action": "kms:CreateAlias",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "590184073875",
          "kms:ViaService": "ec2.us-east-1.amazonaws.com"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "*",
      "Sid": "Allow alias creation during setup"
    },
    {
      "Action": [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ],
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "590184073875"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:590184073875:trail/*"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "*",
      "Sid": "Enable cross account log decryption"
    }
  ],
  "Version": "2012-10-17"
})
}


resource "aws_network_interface" "eni-050ef6dc628244613-c82" {
  attachment {
    device_index = 2
  }
  description     = "9167b27d93be4bf7abca4f004da37c90"
  private_ip      = "192.168.77.144"
  private_ips     = ["192.168.77.144"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-0c577ed793762eea8"
}


resource "aws_network_interface" "eni-06f426dc95d600350-d0c" {
  attachment {
    device_index = 2
  }
  description     = "4adedaec49bf4fd3bdd5bf07ea56d84b"
  private_ip      = "192.168.85.188"
  private_ips     = ["192.168.85.188"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-0c577ed793762eea8"
}


resource "aws_network_interface" "eni-03bd7c124d66f3f2b-fee" {
  attachment {
    device_index = 2
  }
  description     = "ee79b8fd3388439390caed53fd796c69"
  private_ip      = "192.168.107.254"
  private_ips     = ["192.168.107.254"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-032ce0f510d034142"
}


resource "aws_network_interface" "eni-003678204c6c68a5d-491" {
  attachment {
    device_index = 2
  }
  description     = "938f0c4db80f4c44a855c6719e4a482d"
  private_ip      = "192.168.80.111"
  private_ips     = ["192.168.80.111"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-0c577ed793762eea8"
}


resource "aws_network_interface" "eni-04750f638297dc09a-7eb" {
  attachment {
    device_index = 2
  }
  description     = "cedf7fb632ec45feaed0ee61ae941e60"
  private_ip      = "192.168.100.170"
  private_ips     = ["192.168.100.170"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-032ce0f510d034142"
}


resource "aws_network_interface" "eni-0a8423010458e6707-2e7" {
  attachment {
    device_index = 2
  }
  description     = "e3d62ed66adf4a148b4bb47cd5799561"
  private_ip      = "192.168.79.143"
  private_ips     = ["192.168.79.143"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-0c577ed793762eea8"
}


resource "aws_network_interface" "eni-0ea1bb60670de9e5c-1e4" {
  attachment {
    device_index = 2
  }
  description     = "89adf43839614c8b9e1d867555b47ff5"
  private_ip      = "192.168.79.151"
  private_ips     = ["192.168.79.151"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-0c577ed793762eea8"
}


resource "aws_internet_gateway" "Kubernetes-b5d" {
  tags = {
    Name  = "Kubernetes"
    owner = "Robert"
  }
  vpc_id = "vpc-0f3358e78c0cb9a7f"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "aws-cloudtrail-logs-590184073875-4fc539c7-939" {
  bucket = "aws-cloudtrail-logs-590184073875-4fc539c7"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}


resource "aws_s3_bucket_public_access_block" "tfstate-od3tuznbuq-ec7" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "tfstate-od3tuznbuq"
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_network_interface" "eni-0bf51f7847bbb5599-6cb" {
  attachment {
    device_index = 2
  }
  description     = "2a96555b766d452e8c529cd3333ba538"
  private_ip      = "192.168.124.105"
  private_ips     = ["192.168.124.105"]
  security_groups = ["sg-020a769fa8586a8ad"]
  subnet_id       = "subnet-032ce0f510d034142"
}


resource "aws_s3_bucket_versioning" "tfstate-od3tuznbuq-ec7" {
  bucket = "tfstate-od3tuznbuq"
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_acl" "aws-cloudtrail-logs-590184073875-4fc539c7-f06" {
  access_control_policy {
    grant {
      grantee {
        id   = "5e1e91100fb634362d0a4c35d1478d865afce025991c8822e388db3b57b9e583"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    owner {
      display_name = "aws+sep"
      id           = "5e1e91100fb634362d0a4c35d1478d865afce025991c8822e388db3b57b9e583"
    }
  }
  bucket = "aws-cloudtrail-logs-590184073875-4fc539c7"
}


resource "aws_s3_bucket_acl" "tfstate-od3tuznbuq-b02" {
  access_control_policy {
    grant {
      grantee {
        id   = "5e1e91100fb634362d0a4c35d1478d865afce025991c8822e388db3b57b9e583"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    owner {
      display_name = "aws+sep"
      id           = "5e1e91100fb634362d0a4c35d1478d865afce025991c8822e388db3b57b9e583"
    }
  }
  bucket = "tfstate-od3tuznbuq"
}


resource "aws_s3_bucket_public_access_block" "aws-cloudtrail-logs-590184073875-4fc539c7-e6a" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "aws-cloudtrail-logs-590184073875-4fc539c7"
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate-od3tuznbuq-327" {
  bucket = "tfstate-od3tuznbuq"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

