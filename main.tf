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

resource "aws_security_group" "my_security_group" {
  name_prefix = "my_security_group_"
  description = "My security group"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound traffic on port 80 from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.user_ip_address]
  }

  # Allow inbound traffic on port 443 from the user's IP address
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.user_ip_address]
  }
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

  # Other instance configuration options can go here
}

data "aws_s3_bucket" "IgneJone_bucket" {
  bucket = var.S3_BUCKET_NAME

  tags = {
    Name = "IgneJone"
  }
}
