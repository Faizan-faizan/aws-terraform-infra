provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}


#vpc
resource "aws_vpc" "vpc1" {

  cidr_block = var.vpc_cidr_block
  tags = {
    name = var.vpc_name
  }

}

#public subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets_names)


  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(["ap-south-1a", "ap-south-1c"], count.index)
  map_public_ip_on_launch = true

  tags = {

    name = var.public_subnets_names[count.index]

  }

}


#private subnet
resource "aws_subnet" "private_subnet" {


  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "ap-south-1b"

}


#internet gateway
resource "aws_internet_gateway" "in_gw" {
  vpc_id = aws_vpc.vpc1.id

}

#attaching internet gateway
resource "aws_route_table" "public_routes" {
  count = length(var.public_subnets_names)

  vpc_id = aws_vpc.vpc1.id


  route {

    cidr_block = var.global_cidr_block
    gateway_id = aws_internet_gateway.in_gw.id

  }

}


resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets_names)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_routes[count.index].id

}


# Allocate a new Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  instance = null # No instance association, since it will be associated with the NAT Gateway

}


#attaching Nat gateway
resource "aws_nat_gateway" "private_route" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.private_subnet.id

}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc1.id


  route {

    cidr_block = var.global_cidr_block
    gateway_id = aws_nat_gateway.private_route.id

  }

}
resource "aws_route_table_association" "private_subnet_association" {

  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id

}


#creating an instance with private subnet
resource "aws_instance" "private_instance" {
  ami                         = var.ami
  subnet_id                   = aws_subnet.private_subnet.id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  associate_public_ip_address = false

  tags = {

    name = "private-test-server"

  }

}

output "private_subnet_id" {

value = aws_subnet.private_subnet.id

}

output "public_subnet_ids" {

 value = aws_subnet.public_subnets[*].id

}


output "aws_instance_id" {

 value = aws_instance.private_instance.id

}




