provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATQDJYF44DCM52G6P"
    secret_key = "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"
  
}

#1 Create VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "my_dev_vpc"
  }
}

#2 Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "my_dev_igw"
  }
}

#3 Create Custom Route Table
resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my_dev_route"
  }
}

#4 Create a Subnet
resource "aws_subnet" "dev_subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "my_dev_subent"
  }
}

#5 Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_route_table.id
}

#6 Create Security Group to allow ports
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffice"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_security"
  }
}

#7 Create a network Interface with an IP in the Subnet that was created in step:4
resource "aws_network_interface" "web_server_nic" {
  subnet_id       = aws_subnet.dev_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

#8 Assign an elastic IP to the network interface created in step:7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web_server_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
    
}

#9 Create Ubuntu server and install/enable apache2
resource "aws_instance" "my_ec2" {
  ami           = "ami-0756a1c858554433e"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name = "kube"

  network_interface {
    network_interface_id = aws_network_interface.web_server_nic.id
    device_index         = 0
  }  

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  sudo bash -c 'echo This is my first web-server deployment via Terraform!! > /var/www/html/index.html'
  EOF

  tags = {
    Name = "dev_Web-Server_Terraform"
  }
}

