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

resource "aws_s3_bucket_notification" "sandbox_test" {
  bucket = aws_s3_bucket.sandbox_test.id

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events             = ["s3:ObjectCreated:*"]
    filter_prefix      = "${local.target_dir}/"
  }

  depends_on = [module.lambda]
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.sandbox_test.arn
}