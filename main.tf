provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "krepust_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Project-Krepust-VPC-Code"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.krepust_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "Public-Subnet-Code"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.krepust_vpc.id
  tags = {
    Name = "terraform-test"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.krepust_vpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow-Web-SG"
  }
}
