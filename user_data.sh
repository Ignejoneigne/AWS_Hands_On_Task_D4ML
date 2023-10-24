#!/bin/bash

# Set Terraform variables as environment variables
export AWS_REGION="${AWS_REGION}"
export PRIVATE_IP_CIDR="${PRIVATE_IP_CIDR}"
export S3_BUCKET_NAME="${S3_BUCKET_NAME}"
export AMI_ID="${AMI_ID}"
export KEY_PAIR_NAME="${KEY_PAIR_NAME}"
export IAM_INSTANCE_PROFILE="${IAM_INSTANCE_PROFILE}"
export SECURITY_GROUP="${SECURITY_GROUP}"
export INSTANCE_TYPE="${INSTANCE_TYPE}"
export INSTANCE_NAME="${INSTANCE_NAME}"

# Update the system
cd ~
sudo apt update

# Install unzip and git (if not already installed)
sudo apt install -y unzip git

# Download and install Terraform (latest version)
sudo wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Create a directory for your Terraform project
mkdir ~/AWS_task
cd AWS_task

# Clone your Terraform project from GitHub
git clone https://github.com/Ignejoneigne/AWS_Hands_On_Task_D4ML.git

# Initialize Terraform in your project directory
cd AWS_Hands_On_Task_D4ML
terraform init

# Plan your Terraform configuration and save the execution plan
terraform plan -out=tfplan

# Apply the Terraform changes using the saved execution plan
terraform apply tfplan

# Create ec2 instance
aws ec2 run-instances --image-id "${AMI_ID}" --instance-type "${INSTANCE_TYPE}" --key-name "${KEY_PAIR_NAME}" --security-group-ids "${SECURITY_GROUP}" --subnet-id "${PRIVATE_IP_CIDR}" --associate-public-ip-address --user-data file://user_data.sh --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=terraform}]' --iam-instance-profile Name="${IAM_INSTANCE_PROFILE}" --metadata-options http-put-response-hop-limit=1,http-tokens=required

#Terminate ec2 instance
#aws ec2 run-instances --image-id "${AMI_ID}" --instance-type "${INSTANCE_TYPE}" --key-name "${KEY_PAIR_NAME}" --security-group-ids "${SECURITY_GROUP}" --subnet-id "${PRIVATE_IP_CIDR}" --associate-public-ip-address --user-data file://user_data.sh --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=terraform}]' --iam-instance-profile Name="${IAM_INSTANCE_PROFILE}" --metadata-options http-put-response-hop-limit=1,http-tokens=required --instance-initiated-shutdown-behavior terminate
#aws ec2 terminate-instances --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id)


# Upload 500MB file to EC2 instance from S3 bucket and count the time it takes
start_time=$(date +%s)
aws s3 cp s3://d4ml-bucket/ignes/500MB-CZIPtestfile.org.zip /home/ec2-user/500MB-CZIPtestfile.org.zip --region "${AWS_REGION}"
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "Elapsed time for uploading 500MB file: $elapsed_time seconds"


# Create a new folder within the existing "d4ml-bucket"
aws s3api put-object --bucket "${S3_BUCKET_NAME}" --key logs/ --acl bucket-owner-full-control --region "${AWS_REGION}"

# Upload the entire /var/log/ directory to the newly created folder in S3 bucket
aws s3 sync /var/log/ s3://"${S3_BUCKET_NAME}"/logs/ --acl bucket-owner-full-control --region "${AWS_REGION}"

# List the uploaded files and save to a file
aws s3 ls s3://"${S3_BUCKET_NAME}"/logs/ > /var/log/uploaded_files.txt

# Upload the file with uploaded files list to S3
aws s3 cp /var/log/uploaded_files.txt s3://"${S3_BUCKET_NAME}"/logs/uploaded_files.txt

# Create a cron job to run the script every 60 seconds
(crontab -l ; echo "*/5 * * * * /var/snap/amazon-ssm-agent/6312/AWS_task_D4ML/backup_script.sh > /var/log/backup_script.log 2>&1") | crontab -

# automate the uploading of the entire /var/log/ directory to the newly created folder in S3
aws s3 sync /var/log/ s3://"${S3_BUCKET_NAME}"/logs/ --acl bucket-owner-full-control --region "${AWS_REGION}"
