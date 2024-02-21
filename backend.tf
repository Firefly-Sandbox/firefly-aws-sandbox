terraform {
    backend "s3" {
        bucket         	= "tfstate-od3tuznbuq"
        key             = "firefly-sandbox/terraform.tfstate"
        region          = "us-east-1"
        encrypt         = true
        dynamodb_table  = "app-state"
    }
}