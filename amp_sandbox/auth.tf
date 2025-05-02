# Cognito resource for the sandbox test
resource "aws_cognito_user_pool" "sandbox_test" {
  name                     = local.pj_name
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]
  verification_message_template {
    email_message = "The verification code to your new account is {####}"
    email_subject = "Your verification code"
  }
}

resource "aws_cognito_user_pool_client" "sandbox_test" {
  name                                 = local.pj_name
  user_pool_id                         = aws_cognito_user_pool.sandbox_test.id
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
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

}

# ID pool for the sandbox test
resource "aws_cognito_identity_pool" "sandbox_test" {
  identity_pool_name = local.pj_name
  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.sandbox_test.id
    provider_name = aws_cognito_user_pool.sandbox_test.endpoint
  }
}

# Authenticated role trust policy for the sandbox test
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
      values   = [aws_cognito_identity_pool.sandbox_test.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

resource "aws_iam_role" "authenticated" {
  name               = "cognito_authenticated"
  assume_role_policy = data.aws_iam_policy_document.authenticated.json
}

# Identity policy for the authenticated role
data "aws_iam_policy_document" "authenticated_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.sandbox_test.arn}/${local.target_dir}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.sandbox_test.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${local.target_dir}/*", "${local.target_dir}"]
    }
  }
}

resource "aws_iam_role_policy" "authenticated" {
  name   = "authenticated_policy"
  role   = aws_iam_role.authenticated.id
  policy = data.aws_iam_policy_document.authenticated_role_policy.json
}

resource "aws_cognito_identity_pool_roles_attachment" "sandbox_test" {
  identity_pool_id = aws_cognito_identity_pool.sandbox_test.id

  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }

  role_mapping {
    identity_provider         = "${aws_cognito_user_pool.sandbox_test.endpoint}:${aws_cognito_user_pool_client.sandbox_test.id}"
    type                      = "Token"
    ambiguous_role_resolution = "AuthenticatedRole"
  }

}