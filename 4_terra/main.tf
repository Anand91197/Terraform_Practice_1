provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATQDJYF44DCM52G6P"
    secret_key = "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"
  
}

#EC2 machine:
resource "aws_instance" "my_ec2" {
  ami           = "ami-068257025f72f470d"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name = "kube"
 

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing docker"
  sudo apt update -y
  sudo apt install docker.io -y
  sudo systemctl enable --now docker
  docker --version
  echo "*** Completed Installation of docker"
  sudo docker run -it --name my_nginx -p80:80 -d 91197/nginx_custom:1.0
  EOF

  tags = {
    Name = "Docker_Terraform"
  }
}