resource "aws_s3_bucket" "tf_state_locking" {
  bucket = var.s3_state_locking_bucket_name

  tags = {
    Name = "s3_state_locking"
  }
}
