resource "aws_vpc" "second" {
  cidr_block  = var.vpc_cidr
}

resource "aws_internet_gateway" "second" {
  vpc_id = aws_vpc.second.id
}

resource "aws_route_table" "second" {
  vpc_id = aws_vpc.second.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.second.id
  }
}

resource "aws_subnet" "second_one" {
  vpc_id            = aws_vpc.second.id
  cidr_block        = var.one_subnet_cidr
  availability_zone = var.az_one
}

resource "aws_route_table_association" "second_one" {
  subnet_id      = aws_subnet.second_one.id
  route_table_id = aws_route_table.second.id
}

resource "aws_subnet" "second_two" {
  vpc_id            = aws_vpc.second.id
  cidr_block        = var.two_subnet_cidr
  availability_zone = var.az_two
}

resource "aws_route_table_association" "second_two" {
  subnet_id      = aws_subnet.second_two.id
  route_table_id = aws_route_table.second.id
}
