# Flugel Terraform/Github Actions task

This repository contains:

- a terraform module to build:
	-	a S3 bucket with two files, test1.txt and test2.txt. The content of these files must be the timestamp when the Terraform code is executed. (DONE)
	-	two ec2 instances behind an ALB to serve the content from the S3 using traefik (1). (DONE)
	- Security Rules to avoid any external access to the bucket content and only permits access from the ec2 instances behind ALB (DONE)

The idea is to access via http the content of S3 buckets created, only by the ALB

## Requirements

- Terraform 1.0 (can work with Terraform 0.15, but is not guaranteed)
- go 1.15 (for tests)
- AWS IAM Account with permissions to manage fully the S3, EC2, ALB and VPC permissions in programatic way, we will need the Access Key ID and Secret Access Key credentials associated with the account (2)

## Setup

- Define the Environment vars:
    AWS_ACCESS_KEY_ID - with the IAM User AWS Access Key ID
	  AWS_SECRET_ACCESS_KEY - with the IAM User Secret Access Key
	  AWS_DEFAULT_REGION - with the AWS Region where the S3 bucket will be created

- in the shell console execute the commands:
	  terraform init --upgrade=true
	  terraform plan -out run.plan
	  terraform apply "run.plan"
	  terraform output

 - the last command will show the s3 bucket url and the alb url too, you can use it to access the content from the S3 and from the ALB url and check that any access outside the ALB is avoided. You can check the functionality executing the next command:
    wget \`terraform output -raw alb-url\`/test1.txt
	  wget \`terraform output -raw alb-url\`/test2.txt

 - you can try to access directly the S3 from another console without AWS access (without the ENV vars defined previously) and check that the access to the bucket's content is disabled by default.


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



NOTES:
	- The indication email says:
		- Create a cluster of 2 EC2 instances behind an ALB running Traefik, to serve the files in the S3 bucket.
		- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.

  this creates a conflicts because the ALB needs to be defined with at least two public subnets in differents availability zones, inclusive if we use only one instance in a private subnet. The reason is because ALB needs to be provisioned just in case one AZ get out and continue to work with the other/others. The decision was taken to build a public and private subnet per AZ in the AWS Region (3)(4).


(1) we are using docker and docker-compose to run traefik as a container in the EC2 instance
(2) https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
(3) https://stackoverflow.com/questions/50242734/why-does-an-aws-application-load-balancer-require-two-subnets#52839518
(4) https://forums.aws.amazon.com/thread.jspa?threadID=239401

