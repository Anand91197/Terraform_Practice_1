echo "*** Installing docker"
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
docker --version
echo "*** Completed Installation of docker"
sudo docker run -it --name my_apache -p80:80 -d 91197/httpd_custom:1.0
