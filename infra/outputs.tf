output "rds_endpoint" {
  description = "Endpoint of the VaultBridge RDS PostgreSQL database"
  value       = aws_db_instance.vaultbridge.endpoint
}

output "vpc_id" {
  description = "ID of the VaultBridge VPC"
  value       = aws_vpc.main.id
}