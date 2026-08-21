resource "aws_db_subnet_group" "vaultbridge" {
  name = "vaultbridge-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name        = "vaultbridge-db-subnet-group"
    Environment = "dev"
    Project     = "Infrastructure Modernization"
  }
}

resource "aws_db_parameter_group" "vaultbridge" {
  name   = "vaultbridge-postgres15"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = {
    Name        = "vaultbridge-postgres15"
    Environment = "dev"
    Project     = "Infrastructure Modernization"
  }
}

resource "aws_db_instance" "vaultbridge" {
  identifier     = "vaultbridge-db"
  engine         = "postgres"
  engine_version = "15.13"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "vaultbridge"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.vaultbridge.name
  parameter_group_name   = aws_db_parameter_group.vaultbridge.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "vaultbridge-rds"
    Environment = "dev"
    Project     = "Infrastructure Modernization"
  }
}