# Flugel Terraform/Github Actions task

This repository contains:

- a terraform module to build:
	-	a S3 bucket with two files, test1.txt and test2.txt. The content of these files must be the timestamp when the Terraform code is executed. (DONE)
	-	two ec2 instances behind an ALB to serve the content from the S3 using traefik (1). (IN PROCESS)
	- Security Rules to avoid any external access to the bucket content and only permits access from the ec2 instances behind ALB (TODO)

The idea is to access via http the content of S3 buckets created  by the ALB Only

## Requirements

- Terraform 1.0 (can work with Terraform 0.15, but is not guaranteed)
- go 1.15 (for tests)
- AWS IAM Account with permissions to manage S3 in programatic way, we will need the Access Key ID and Secret Access Key credentials associated with the account (2)

## Setup

- Define the Environment vars:
	-	AWS_ACCESS_KEY_ID - with the IAM User AWS Access Key ID
	-	AWS_SECRET_ACCESS_KEY - with the IAM User Secret Access Key
	-	AWS_DEFAULT_REGION - with the AWS Region where the S3 bucket will be created
- in the shell console execute the commands:
	- terraform init --upgrade=true
	- terraform plan -out run.plan
	- terraform apply "run.plan"
	- terraform output

	the last command will show the s3 bucket url and the alb url too, you can use it (IN PROCESS) to access the content from the S3 and from the ALB url and check that any access outside the ALB is avoided (3)

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



TODO:
	- finish private index config
	- finish the ALB config to use the private instances


(1) we are using docker and docker-compose to run traefik as a container in the EC2 instance
(2) https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
(3) by now we are deploying and EC2 instance in one of the public subnets to test first Traefik configuration
