provider "aws" {
  region = "ap-south-1"  # You can choose any region
}

# Create a Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-app-sg"
  description = "Allow HTTP, SSH, and Docker"

  # Ingress rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule for all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Use a valid Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = "assignment-key-pair"  # Provide your SSH key pair name

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Docker-Web-App"
  }

  # Optionally, assign an Elastic IP to the EC2 instance (if needed)
  associate_public_ip_address = true
}

# Output the Public IP of the EC2 instance
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
