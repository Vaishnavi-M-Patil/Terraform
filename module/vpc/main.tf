resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr
    tags = {
      name = "My-VPC"
    }
}

resource "aws_subnet" "pvt_subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.pvt_cidr
    tags = {
      name ="Private-subnet"
    }
}

resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.pub_cidr
    map_public_ip_on_launch = true
    tags = {
      name = "Public-subnet"
    }
}

resource "aws_internet_gateway" "ingw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      name = "Internet-Gateway"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ingw.id
    }
}

resource "aws_route_table_association" "publicRTAsso" {
    subnet_id = aws_subnet.pub_subnet.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "newSecuritygrp" {
  name = "newSecGroup"
  vpc_id = aws_vpc.myvpc.id
  tags = {
    name = "myvpc-security-group"
  }

  #inbound rules
  ingress {             
    description = "HTTP"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }
  ingress {
    description = "Allow ICMP Echo Request"
    from_port   = 8                
    to_port     = -1               # -1 = all codes for that type
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]    # Allow from anywhere
  }

#outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"              # -1 means all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
