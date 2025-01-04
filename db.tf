resource "aws_db_instance" "phpdb" {
  identifier_prefix   = "terraform-mysql"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
}

variable "db_name" {
  description = "The name for the database"
  type        = string
  sensitive   = true
  default     = "webtest"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = "testuser"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = "testpass"
}

output "address" {
  value       = aws_db_instance.phpdb.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.phpdb.port
  description = "The port the database is listening on"
}

# address:port = endpoint
output "endpoint" {
  value       = aws_db_instance.phpdb.endpoint
  description = "The endpoint of database"
}
