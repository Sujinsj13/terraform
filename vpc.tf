# ---------- VPC ----------
resource "aws_vpc" "coke" {
  cidr_block           = "10.0.0.0/16"
 
  tags = {
    Name = "coke-vpc"
  }
}
 
# ---------- Internet Gateway ----------
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.coke.id
 
  tags = {
    Name = "coke-igw"
  }
}
 
# ---------- Public Subnet ----------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.coke.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "public-subnet"
  }
}
 
# ---------- Private Subnet ----------
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.coke.id
  cidr_block        = "10.0.2.0/24"
 
  tags = {
    Name = "private-subnet"
  }
}
 
# ---------- Elastic IP for NAT ----------
resource "aws_eip" "nat" {
  domain = "vpc"
 
  tags = {
    Name = "nat-eip"
  }
}
 
# ---------- NAT Gateway ----------
resource "aws_nat_gateway" "coke-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
 
  tags = {
    Name = "gw-NAT"
  }
 
  depends_on = [aws_internet_gateway.vpc-igw]
}
 
# ---------- Public Route Table ----------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.coke.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
 
  tags = {
    Name = "public-rt"
  }
}
 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
 
# ---------- Private Route Table ----------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.coke.id
 
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.coke-nat.id
  }
 
  tags = {
    Name = "private-rt"
  }
}
 
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
 
