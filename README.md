# AWS_task_D4ML

Hands On task AWS

Description:

As a junior DevOps engineer, you need to prove to your client that it is possible to upload 500MB of file from EC2 Instance to an S3 bucket and automate this procedure.

A client wants to know:
1. Which resources will be created during the procedure
2. How long will it take to upload a 500MB file from EC2 t2.micro to S3 bucket
3. Provide monitoring graph from AWS (eg. Cloudwatch)


What must be done:
All the steps should be executed in EC2.
Resource provision must be done by Terraform
Upload a 500MB file from EC2 t2.micro to S3 bucket
Instead of a file, you need to automate the uploading of the entire /var/log/ directory
File with uploaded files list should be in S3 bucket as well
IMDSv2 method must be used to retrieve instance data.
Automate this procedure

Afterward, the instance should be terminated automatically.


AWS settings:
Use existing D4ML AMI - "ami-d4ml-2022-10-05T10-47-38Z"
IAM instance profile - use "role-d4ml-cloud9-deployment" 
AWS credentials - we do not use static IAM credentials in this project
Create and use an S3 folder within the existing "d4ml-bucket"
Region - "eu-central-1"
