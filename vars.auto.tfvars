s3_bucket_name_prefix = "flugel-bucket-"
s3_acl                = "public-read"

filename_format = "test%d.txt"
file_count      = 2

vpc_cidr    = "10.0.0.0/16"
one_subnet_cidr = "10.0.0.0/24"
two_subnet_cidr = "10.0.1.0/24"
subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24"]

ec2_instances = 2

region = "us-west-2"
az_one = "us-west-2a"
az_two = "us-west-2b"
az = ["us-west-2a", "us-west-2b"]
