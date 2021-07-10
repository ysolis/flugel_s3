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

resource "aws_subnet" "second" {
  vpc_id            = aws_vpc.second.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.az[count.index]
  count             = 2
}

resource "aws_route_table_association" "second" {
  subnet_id       = aws_subnet.second[count.index].id
  route_table_id  = aws_route_table.second.id
  count           = 2
}

resource "aws_eip" "second" {
  vpc = true
}

resource "aws_nat_gateway" "second" {
  allocation_id = aws_eip.second.id
  subnet_id     = aws_subnet.second.*.id[0]
}
