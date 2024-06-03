resource "aws_db_subnet_group" "newsfit_db_subnet_group" {
  name       = "newsfit_db_subnet_group"
  subnet_ids = [aws_subnet.newsfit_vpc_private_subnet_1.id, aws_subnet.newsfit_vpc_private_subnet_2.id]

  tags = {
    Name = "newsfit_db_subnet_group"
  }
}

resource "aws_db_instance" "newsfit_mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.newsfit_db_subnet_group.name
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.newsfit_rds_sg.id]

  tags = {
    Name = "newsfit_mysql"
  }
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS"
  value       = aws_db_instance.newsfit_mysql.endpoint
}