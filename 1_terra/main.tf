provider "aws" {
    region = "ap-south-1"
  
}

resource "aws_s3_bucket" "my_s3_bucket" {

    bucket = "anand-terraform-bucket-01"
}

resource "aws_s3_bucket_versioning" "versioning_my_s3_bucket" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_iam_user" "my_iam_user" {
    name = "test_user_terraform"
  
}
