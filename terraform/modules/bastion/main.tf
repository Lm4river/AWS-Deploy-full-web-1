provider "aws" {
  region = var.region
}

resource "aws_key_pair" "udemy-keypair" {
  key_name   = "udemy-keypair"
  public_key = file("${path.module}/keypair/udemy-key.pub")
}

resource "aws_instance" "bastion-instance" {
  ami           = var.amis[var.region]
  instance_type = var.instance_type
  key_name      = aws_key_pair.udemy-keypair.key_name
  tags = {
    Name = "Udemy DevOps Bastion"
  }
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  #Userdata to install Mongo Client
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get install gnupg curl
              curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
                sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
                --dearmor
              echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
              sudo apt-get update
              sudo apt-get install -y mongodb-org
              EOF
}

resource "aws_eip" "demo-eip" {
  instance = aws_instance.bastion-instance.id
}


