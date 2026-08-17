variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}

variable "my_ip_cidr" {
  description = "Public IP address in CIDR notation allowed to access the EC2 instance"
  type        = string
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}