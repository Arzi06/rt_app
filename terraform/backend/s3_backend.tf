
resource "aws_s3_bucket" "tf_remote_state" {
  bucket = "eks-s3-backend-with-locking"
  force_destroy   = true
  lifecycle {
    prevent_destroy = false
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# locking part
resource "aws_dynamodb_table" "tf_remote_state_locking" {
  hash_key = "LockID"
  name = "eks-s3-backend-locking"
  read_capacity  = 1
  write_capacity = 5 
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}