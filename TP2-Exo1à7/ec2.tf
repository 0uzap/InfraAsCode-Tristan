# Generate SSH key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}


	
data "aws_ami" "amazon_linux_2" {
  most_recent = true
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
 
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
 
  owners = ["amazon"]
}


# # Create EC2 instance with Nginx
# resource "aws_instance" "web" {
#   ami             = data.aws_ami.amazon_linux_2.id
#   instance_type   = var.instance_type
#   security_groups = [aws_security_group.web.name]
#   key_name        = aws_key_pair.deployer.key_name

#   user_data = <<-EOF
#               #!/bin/bash
#               # Install and configure Nginx
#               yum update -y
#               yum install -y nginx
#               systemctl start nginx
#               systemctl enable nginx
              
#               # Create a simple webpage
#               echo "<h1>Hello from Terraform sur AWS!</h1>" > /usr/share/nginx/html/index.html
#               EOF

#   tags = {
#     Name = var.instance_name
#   }
# }

resource "aws_instance" "web" {
  ami               = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.web.name]
  key_name          = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Installation Docker
              amazon-linux-extras install docker -y


              # Docker pour Wordpress
              docker network create wordpress-network

              # Lancement MySQL
              docker run -d \
                --name mysql \
                --network wordpress-network \
                -e MYSQL_ROOT_PASSWORD=${var.wordpress_db_root_password} \
                -e MYSQL_DATABASE=${var.wordpress_db_name} \
                -e MYSQL_USER=${var.wordpress_db_user} \
                -e MYSQL_PASSWORD=${var.wordpress_db_password} \
                -v mysql_data:/var/lib/mysql \
                mysql:5.7

              # Attente démarrage sql
              sleep 30

              # Lancement wordpress
              docker run -d \
                --name wordpress \
                --network wordpress-network \
                -p 80:80 \
                -e WORDPRESS_DB_HOST=mysql:3306 \
                -e WORDPRESS_DB_NAME=${var.wordpress_db_name} \
                -e WORDPRESS_DB_USER=${var.wordpress_db_user} \
                -e WORDPRESS_DB_PASSWORD=${var.wordpress_db_password} \
                -v wordpress_data:/var/www/html \
                wordpress:latest

              EOF
  tags = {
    Name = "wordpress-server"
  }
}


# resource "aws_instance" "db" {
#   ami             = data.aws_ami.amazon_linux_2.id
#   instance_type   = var.instance_type
#   security_groups = [aws_security_group.web.name]
#   key_name        = aws_key_pair.deployer.key_name

#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y

#               # Installation MySQL
#               yum install -y mariadb-server

#               # Démarration service
#               systemctl start mariadb
#               systemctl enable mariadb

#               # Création bdd basique
#               mysql -e "CREATE DATABASE apptest;"

#               EOF

#   tags = {
#     Name = var.db_instance_name
#     Role = "database"
#   }
# }