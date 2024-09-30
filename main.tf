# Declare KMS keys
resource "aws_kms_key" "examplekms" {
  description = "KMS key for S3 object encryption"
}

resource "aws_kms_key" "example1kms" {
  description = "KMS key for S3 object encryption (error.html)"
}

resource "aws_kms_key" "example2kms" {
  description = "KMS key for S3 object encryption (profile.png)"
}

# Create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "example" {
  key        = "index.html"
  bucket     = aws_s3_bucket.mybucket.id
  source     = "index.html"
  kms_key_id = aws_kms_key.examplekms.arn
}

resource "aws_s3_object" "example1" {
  key        = "error.html"
  bucket     = aws_s3_bucket.mybucket.id
  source     = "error.html"
  kms_key_id = aws_kms_key.example1kms.arn
}

resource "aws_s3_object" "example2" {
  key        = "profile.png"
  bucket     = aws_s3_bucket.mybucket.id
  source     = "profile.png"
  kms_key_id = aws_kms_key.example2kms.arn
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]
}
