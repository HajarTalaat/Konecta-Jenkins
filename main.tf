provider "aws" {
  region = var.aws_region
}

# Generate a new SSH key pair
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  filename        = "${path.module}/terraform-key.pem"
  content         = tls_private_key.terraform_key.private_key_pem
  file_permission = "0600"
}

# Security Group
resource "aws_security_group" "instance_sg" {
  name        = "allow_ssh_docker"
  description = "Allow SSH and Docker access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Update for security
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Needed for Jenkins
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CICD Machine
resource "aws_instance" "cicd_machine" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name  
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "CICD-Machine"
  }
}

# Production Machine
resource "aws_instance" "prod_machine" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name  # Use the generated key pair
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "Production-Machine"
  }
}
