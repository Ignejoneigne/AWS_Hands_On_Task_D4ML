/*provider "aws" {
  region = var.AWS_region
  profile = "default"

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

*/


resource "aws_instance" "IgneJone_instance_1" {
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
