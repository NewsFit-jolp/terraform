resource "aws_vpc" "newsfit_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "newsfit_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.newsfit_vpc.id

  tags = {
    Name = "newsfit_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.newsfit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "newsfit_public_rt"
  }
}

resource "aws_subnet" "newsfit_vpc_public_subnet_1" {
  vpc_id            = aws_vpc.newsfit_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.newsfit_vpc_public_subnet_1_availability_zone

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.newsfit_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "newsfit_vpc_public_subnet_2" {
  vpc_id            = aws_vpc.newsfit_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.newsfit_vpc_public_subnet_2_availability_zone

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.newsfit_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "newsfit_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.newsfit_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.newsfit_vpc_private_subnet_1_availability_zone

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "newsfit_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.newsfit_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.newsfit_vpc_private_subnet_2_availability_zone

  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_security_group" "newsfit_sg" {
  name   = "newsfit_sg"
  vpc_id = aws_vpc.newsfit_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.newsfit_sg_ingress_22_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.newsfit_sg_ingress_80_cidr_blocks
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.newsfit_sg_ingress_8080_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.newsfit_sg_ingress_443_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.newsfit_sg_engress_cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "newsfit_rds_sg" {
  name   = "newsfit_rds_sg"
  vpc_id = aws_vpc.newsfit_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.newsfit_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.newsfit_sg_engress_cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.newsfit_sg]

}


output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.newsfit_vpc.id
}

output "public_subnet_1_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.newsfit_vpc_public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.newsfit_vpc_public_subnet_2.id
}

output "private_subnet_1_id" {
  description = "The ID of the private subnet 1"
  value       = aws_subnet.newsfit_vpc_private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "The ID of the private subnet 2"
  value       = aws_subnet.newsfit_vpc_private_subnet_2.id
}
