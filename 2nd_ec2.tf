resource "aws_security_group" "second" {
  name = "second rules"
  vpc_id = aws_vpc.second.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "second" {
    ami                     = data.aws_ami.ubuntu.id
    instance_type           = "t3.micro"
    subnet_id               = aws_subnet.second[count.index].id
    vpc_security_group_ids  = [aws_security_group.second.id]

    tags = {
        Name = "second"
    }

    count = 2
}
