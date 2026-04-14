resource "aws_s3_bucket" "s3_bucket" {
  region           = var.region
  bucket           = var.bucket_name
  bucket_namespace = var.regional_s3_bucket_namespace ? "account-regional" : "global"

  tags = {
    Name       = var.bucket_name
    env        = var.env
    managed-by = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  region = aws_s3_bucket.s3_bucket.region
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = var.versioning
  }
}