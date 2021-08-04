s3_bucket_name_prefix = "flugel-bucket-"
s3_acl                = "private"

filename_format = "test%d.txt"
file_count      = 2

vpc_cidr            = "10.0.0.0/16"
subnet_public_cidr  = "10.0.254.0/24"
subnet_private_cidr = ["10.0.0.0/24", "10.0.1.0/24"]

ec2_instances = 2

region = "us-west-2"
