locals {
  az_names = data.aws_availability_zones.azs.names
}

resource "aws_vpc" "second" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true

  tags = {
    Name = "SecondVPC"
  }

}

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.second.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }

  count                   = length(slice(local.az_names, 0, 2))
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.second.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.second.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id       = aws_subnet.public[count.index].id
  route_table_id  = aws_route_table.public_rt.id
  count           = length(slice(local.az_names, 0, 2))
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.second.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, count.index + length(slice(local.az_names, 0, 2)))
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }

  count             = length(slice(local.az_names, 0, 2))
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.second.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "second" {
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private_rt.id
  count           = length(slice(local.az_names, 0, 2))
}
