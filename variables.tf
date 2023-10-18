variable "AWS_REGION" {
  type    = string
  description = "The AWS region where resources will be created."
}

variable "PRIVATE_IP_CIDR" {
  type    = string
  description = "The private IP CIDR for EC2 instance."
}

variable "S3_BUCKET_NAME" {
  type    = string
  description = "The name of the S3 bucket for storing data."
}

variable "AMI_ID" {
  type    = string
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance."
}

variable "KEY_PAIR_NAME" {
  type    = string
  description = "The name of the EC2 key pair to associate with the instance."
}

variable "IAM_INSTANCE_PROFILE" {
  type    = string
  description = "The name of the IAM instance profile to associate with the EC2 instance."
}

variable "SECURITY_GROUP" {
  type    = string
  description = "The ID of the security group for the EC2 instance."
}

variable "INSTANCE_TYPE" {
  type    = string
  description = "The type of the EC2 instance to create."
}

variable "INSTANCE_NAME" {
  type    = string
  description = "The name of the EC2 instance."
}
