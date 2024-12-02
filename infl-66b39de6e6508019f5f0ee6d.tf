resource "aws_iam_role" "AssetCounter" {
  assume_role_policy  = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::590184073875:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "REDACTED-BY-FIREFLY:d68129404ef3ca8415e1a46ad2c565213b8feefe2f37c5d409572124518b16cb:sha256"
        }
      }
    }
  ]
})
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  name                = "AssetCounter"
  # The following attributes are sensitive values redacted by Firefly and should be replaced with your own: [assume_role_policy]
  lifecycle {
    ignore_changes = [assume_role_policy]
  }
}

