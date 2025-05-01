resource "aws_amplify_app" "app" {
    name = "amplify-test-app"
    repository = var.REPOSITORY_URL
    access_token = var.GITHUB_TOKEN
    build_spec = templatefile("${path.module}/amplify.yml", {})
    environment_variables = {
        APP_IDENTITY_POOL_ID = var.APP_IDENTITY_POOL_ID
        APP_REGION = var.APP_REGION
        APP_USER_POOL_ID = var.APP_USER_POOL_ID
        APP_WEB_CLIENT_ID = var.APP_WEB_CLIENT_ID
        APP_S3_BUCKET_NAME = var.APP_S3_BUCKET_NAME
    }
    iam_service_role_arn = aws_iam_role.svc_role.arn
}

resource "aws_amplify_branch" "main" {
    app_id = aws_amplify_app.app.id
    branch_name = "main"
    enable_auto_build = true
}

resource "aws_iam_role" "svc_role" {
  name = "svc-role-for-amplify"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.svc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmplifyBackendDeployFullAccess"
}
