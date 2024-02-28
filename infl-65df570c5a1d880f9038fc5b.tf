resource "aws_vpc" "acme-prod-vpc-572" {
  cidr_block                     = "10.0.0.0/24"
  enable_classiclink_dns_support = false
  tags = {
    Name    = "acme-prod-vpc"
    purpose = "acme-prod"
  }
}


resource "aws_default_network_acl" "acl-0e55cbb1c9fc457a1-568" {
  default_network_acl_id = "acl-0e55cbb1c9fc457a1"
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


resource "aws_route_table" "rtb-09a82c140058f68f2-46c" {
  vpc_id = "vpc-0a9f81e0f33455180"
}

