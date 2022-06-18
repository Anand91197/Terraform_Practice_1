provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATQDJYF44DCM52G6P"
    secret_key = "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"
  
}
#Multiple IAM User
/*resource "aws_iam_user" "my_iam_users" {
    count = 2
    name = "test_user_terraform.${count.index}"
  
}*/

#EC2 Ubuntu
resource "aws_instance" "my_ec2" {
  ami           = "ami-0756a1c858554433e"
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu_Terraform"
  }
}

#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Dev-VPC"
  }
}

#Subnet
resource "aws_subnet" "subnet_my" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Dev-Subent"
  }
}