resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = var.ddb_state_locking_table_name
  hash_key = "LockID"
  read_capacity = 5
  write_capacity = 5
 
  attribute {
    name = "LockID"
    type = "S"
  }
}