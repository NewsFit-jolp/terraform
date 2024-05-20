resource "aws_dynamodb_table" "announcement" {
  name           = var.ddb_url_table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "url"

  attribute {
    name = "url"
    type = "S"
  }

  tags = {
    Name        = "url"
  }
}
