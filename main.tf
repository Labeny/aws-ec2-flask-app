provider "aws" {
  region = "eu-north-1"
}

# 1. Newest Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. VPC
resource "aws_vpc" "krepust_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Project-Krepust-VPC"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.krepust_vpc.id
  tags = {
    Name = "Main-Gateway"
  }
}

# 4. Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.krepust_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "Public-Subnet"
  }
}

# 5. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.krepust_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

# 6. Connecting to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  vpc_id      = aws_vpc.krepust_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. Server
resource "aws_instance" "flask_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id 
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  associate_public_ip_address = true
  


  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Flask-App-Server"
  }
}

# 9. Result
output "server_public_ip" {
  value = aws_instance.flask_server.public_ip
}
