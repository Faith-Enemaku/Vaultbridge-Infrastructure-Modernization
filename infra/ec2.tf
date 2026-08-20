data "aws_ami" "al2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "vaultbridge" {
  key_name   = "vaultbridge-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "vaultbridge" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  key_name = aws_key_pair.vaultbridge.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y postgresql15
              EOF

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 30
  }

  tags = {
    Name        = "vaultbridge-ec2"
    Environment = "dev"
    Project     = "Infrastructure Modernization"
  }
}

resource "aws_eip" "vaultbridge" {
  instance = aws_instance.vaultbridge.id

  tags = {
    Name        = "vaultbridge-eip"
    Environment = "dev"
  }
}

output "ec2_public_ip" {
  description = "Elastic IP address of the VaultBridge EC2 instance"
  value       = aws_eip.vaultbridge.public_ip
}