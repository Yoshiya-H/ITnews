# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name ="ecs-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ecs-igw"
  }
}

# Public Subnet A
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs-public-subnet-a"
  }
}

# Public Subnet C
resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs-public-subnet-c"
  }
}

# Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ecs-public-route-table"
  }
}

# Route table association for subnet a
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Route table association for subnet c
resource "aws_route_table_association" "c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}