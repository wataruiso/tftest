resource "aws_s3_bucket" "ampbk_bucket" {
  bucket = var.APP_S3_BUCKET_NAME
}