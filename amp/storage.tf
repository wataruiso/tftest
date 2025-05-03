# Storage bucket for the sandbox test
resource "aws_s3_bucket" "sandbox_test" {
  bucket = local.pj_name
  tags = {
    "name" = local.pj_name
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.sandbox_test.arn}/*",
      aws_s3_bucket.sandbox_test.arn,
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.sandbox_test.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_cors_configuration" "sandbox_test" {
  bucket = aws_s3_bucket.sandbox_test.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "HEAD",
      "PUT",
      "POST",
      "DELETE"
    ]
    allowed_origins = ["*"]
    expose_headers = [
      "x-amz-server-side-encryption",
      "x-amz-request-id",
      "x-amz-id-2",
      "ETag"
    ]
    max_age_seconds = 3000
  }

}