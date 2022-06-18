provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATQDJYF44DCM52G6P"
    secret_key = "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"
  
}

#EC2 machine:
resource "aws_instance" "my_ec2" {
  ami           = "ami-079b5e5b3971bd10d"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name = "kube"
  user_data = file("httpd.sh")
  
  tags = {
    Name = "Docker_Apache_Terraform"
  }
}