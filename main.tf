resource "aws_vpc" "latam" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC LATAM"
    Location = "US"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id = aws_vpc.latam.id
  count = length(data.aws_availability_zones.avz.names)
  availability_zone = element(data.aws_availability_zones.avz.names, count.index)
  cidr_block = element(var.subnets_cidr, count.index)

  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.latam.id
  tags = {
    Name = "VPC Latam"
  }
}

resource "aws_route_table" "web_public" {
  vpc_id = aws_vpc.latam.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public route for web applications "
  }
}

resource "aws_route_table_association" "public_subnet" {
  count = length(var.subnets_cidr)
  subnet_id = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = aws_route_table.web_public.id
}