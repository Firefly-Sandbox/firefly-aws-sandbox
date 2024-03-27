import {
  to = aws_vpc.acme-prod-vpc-572
  id = "vpc-0a9f81e0f33455180"
}


resource "aws_vpc" "acme-prod-vpc-572" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name    = "acme-prod-vpc"
    purpose = "acme-prod"
  }
}

