variable "pj_name" {}
variable "endpoint_id" {}

resource "aws_api_gateway_rest_api" "private_api_test" {
  name        = "private_api_test"
  description = "Private API for testing"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.endpoint_id]
  }
  tags = {
    Name = var.pj_name
  }
}

resource "aws_api_gateway_deployment" "private_api_test" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
}

resource "aws_api_gateway_stage" "private_api_test" {
  stage_name    = "test"
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  deployment_id = aws_api_gateway_deployment.private_api_test.id
}

resource "aws_api_gateway_account" "private_api_test" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  stage_name  = aws_api_gateway_stage.private_api_test.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}

# resource "aws_api_gateway_rest_api_policy" "api_policy" {
#   rest_api_id = aws_api_gateway_rest_api.private_api_test.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = "*",
#         Action = "execute-api:Invoke",
#         Resource = "${aws_api_gateway_rest_api.private_api_test.execution_arn}/*/*/*",
#         Condition = {
#           StringEquals = {
#             "aws:SourceVpc": var.endpoint_id
#           }
#         }
#       }
#     ]
#   })
# }

resource "aws_cognito_user_pool" "private_api_test" {
  name = "private_api_test"
}

resource "aws_cognito_user" "testuser" {
  user_pool_id = aws_cognito_user_pool.private_api_test.id
  username     = "testuser"
  password     = "Testuser123!"
}

resource "aws_cognito_user_pool_client" "private_api_test" {
  name                                 = "private_api_test"
  user_pool_id                         = aws_cognito_user_pool.private_api_test.id
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin"
  ]
  prevent_user_existence_errors = "ENABLED"
  callback_urls                 = ["https://example.com"]
  supported_identity_providers  = ["COGNITO"]
  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH",
  ]
}

resource "aws_cognito_identity_pool" "private_api_test" {
  identity_pool_name = "private_api_test"
  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.private_api_test.id
    provider_name = aws_cognito_user_pool.private_api_test.endpoint
  }
}

data "aws_iam_policy_document" "authenticated" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.private_api_test.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

resource "aws_iam_role" "authenticated" {
  name               = "api_gateway_authenticated"
  assume_role_policy = data.aws_iam_policy_document.authenticated.json  
}

resource "aws_iam_role_policy_attachment" "authenticated" {
  role   = aws_iam_role.authenticated.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_cognito_identity_pool_roles_attachment" "private_api_test" {
  identity_pool_id = aws_cognito_identity_pool.private_api_test.id

  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }

  role_mapping {
    identity_provider         = "${aws_cognito_user_pool.private_api_test.endpoint}:${aws_cognito_user_pool_client.private_api_test.id}"
    type                      = "Token"
    ambiguous_role_resolution = "AuthenticatedRole"
  }

}

resource "aws_api_gateway_authorizer" "private_api_test" {
  name          = "private_api_test"
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.private_api_test.arn]
}

# $ aws cognito-idp admin-initiate-auth \
# --user-pool-id CognitoユーザープールID \
# --client-id アプリクライアントID \
# --auth-flow ADMIN_NO_SRP_AUTH \
# --auth-parameters USERNAME=ユーザ名,PASSWORD=パスワード
