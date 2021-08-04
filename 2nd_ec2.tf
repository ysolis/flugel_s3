resource "aws_security_group" "sg_ec2" {
  name = "second rules"
  vpc_id = aws_vpc.second.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name                = "s3-role"
  path                = "/"
  assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            }
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name  = "ec2_profile"
  role  = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_iam_role_policy" "access_s3" {
  name        = "acess-s3-policy"
  role        = aws_iam_role.ec2_s3_access_role.name
  policy      = templatefile("files/inline_policy.json",{
    arn = aws_s3_bucket.flugel_s3_bucket.arn,
  })
}

resource "aws_instance" "private" {

  depends_on              = [
    aws_nat_gateway.nat_gw,
    aws_s3_bucket.flugel_s3_bucket
  ]

  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.private[count.index].id
  user_data               = templatefile("files/cloud_config.yml",{
    s3bucket = aws_s3_bucket.flugel_s3_bucket.id
  })
  vpc_security_group_ids  = [aws_security_group.sg_ec2.id]
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "alb_node"
  }

  count = 2
}
