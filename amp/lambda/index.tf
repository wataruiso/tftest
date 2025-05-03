locals {
  func_file = {
    name = "index"
    ext  = "py"
  }
}

variable "pj_name" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
    role       = aws_iam_role.iam_for_lambda.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/${local.func_file.name}.${local.func_file.ext}"
  output_path = "${path.module}/function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.module}/function_payload.zip"
  function_name = "sample_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "${local.func_file.name}.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"

  tags = {
    "name" = var.pj_name
  }
#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
}