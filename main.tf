terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 🔑 Create a new key pair and save private key locally
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "springboot-auto-key"
  public_key = tls_private_key.this.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  filename        = "${path.module}/springboot-auto-key.pem"
  content         = tls_private_key.this.private_key_pem
  file_permission = "0400"
}

# 🔒 Security group for SSH + HTTP
resource "aws_security_group" "allow_web" {
  name        = "springboot-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "springboot-sg"
  }
}

# 🖥️ EC2 Instance
resource "aws_instance" "spring_app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "springboot-auto-deploy"
  }
}

# 📤 Outputs
output "instance_public_ip" {
  value = aws_instance.spring_app.public_ip
}

output "ssh_key_file" {
  value       = local_file.private_key.filename
  description = "Path to the private key file to SSH into the instance"
}
