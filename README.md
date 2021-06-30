# Flugel Terraform/Github Actions task

This repository contains a terraform module to build a S3 bucket with two files, test1.txt and test2.txt. The content of these files must be the timestamp when the Terraform code is executed.

## Requirements

- Terraform 1.0 (can work with Terraform 0.15, but is not guaranteed)
- go 1.15 (for tests)
- AWS IAM Account with permissions to manage S3 in programatic way, we will need the Access Key ID and Secret Access Key credentials associated with the account (1)

## Setup

- Define the Environment vars:
	-	AWS_ACCESS_KEY_ID - with the IAM User AWS Access Key ID
	-	AWS_SECRET_ACCESS_KEY - with the IAM User Secret Access Key
	-	AWS_DEFAULT_REGION - with the AWS Region where the S3 bucket will be created
- in the shell console execute the commands:
	- terraform init --upgrade=true
	- terraform plan -out run.plan
	- terraform apply "run.plan"

## Test

For test we use a terratest go script to create the bucket, the bucket objects, checked the correct filenames and after this destroy the content created.

- cd test
-	go mod init "github.com/ysolis/flugel_s3"
-	go get -v -t -d
-	go mod tidy
-	go test -v

## Github Action

We have defined a github action workflow to automatically check the code with the terratest go script. To use it you will need to define three repository secrets:
-	AWS_ACCESS_KEY_ID
-	AWS_SECRET_ACCESS_KEY
-	AWS_DEFAULT_REGION

with the same values that we see in **Setup**




(1) https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
