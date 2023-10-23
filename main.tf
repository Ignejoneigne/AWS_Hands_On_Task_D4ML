terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

resource "aws_instance" "IgneJone_instance" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE
  iam_instance_profile = var.IAM_INSTANCE_PROFILE
  user_data = file("user_data.sh")
}

resource "aws_s3_bucket" "IgneJone_bucket" {
  bucket = var.S3_BUCKET_NAME

  tags = {
    Name = "IgneJone"
  }
}

metadata "http_tokens" {
  http_tokens             = "required"
  http_put_response_hop_limit = 3
  http_endpoint           = "enabled"
}
