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

resource "aws_key_pair" "mykey" {
  key_name    = "mykey"
  public_key  = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "instance" {

  depends_on              = [
    aws_instance.public,
    aws_nat_gateway.nat_gw
  ]

  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.private[count.index].id
  key_name                = aws_key_pair.mykey.key_name
  user_data               = templatefile("files/cloud_config.yml",{
    s3bucket = aws_s3_bucket.flugel_s3_bucket.bucket_regional_domain_name
  })
  vpc_security_group_ids  = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "alb_node"
  }

  count = 2
}

resource "aws_instance" "public" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.public[0].id
  key_name                = aws_key_pair.mykey.key_name
  user_data               = templatefile("files/cloud_config.yml",{
    s3bucket = aws_s3_bucket.flugel_s3_bucket.bucket_regional_domain_name
  })
  vpc_security_group_ids  = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public"
  }
}
