# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Create Key Pair
resource "aws_key_pair" "default" {
  key_name   = "Terraform-key"
  public_key = file("/home/codespace/.ssh/id_rsa.pub")
}

# Create a Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
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

# Create EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "ec2-throughTerraform"
  }
}

# Outputs
output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "public_key" {
  value = aws_key_pair.default.key_name
}

output "public_dns" {
  value = aws_instance.ec2.public_dns
}