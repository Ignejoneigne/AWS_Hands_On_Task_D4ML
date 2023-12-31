provider "aws" {
  region = var.AWS_REGION
} 



resource "aws_instance" "IgneJone_instance" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE
  iam_instance_profile = var.IAM_INSTANCE_PROFILE
  user_data = file("user_data.sh")

  metadata_options {
    http_tokens             = "required"
    http_put_response_hop_limit = 3
    http_endpoint           = "enabled"
  }
}

resource "aws_s3_bucket" "IgneJone_bucket" {
  bucket = var.S3_BUCKET_NAME

  tags = {
    Name = "IgneJone"
  }
}
