resource "aws_amplify_app" "app" {
    name = "amplify-test-app"
    repository = var.REPOSITORY_URL
    build_spec = templatefile("${path.module}/amplify.yml", {})
    environment_variables = {
        APP_IDENTITY_POOL_ID = var.APP_IDENTITY_POOL_ID
        APP_REGION = var.APP_REGION
        APP_USER_POOL_ID = var.APP_USER_POOL_ID
        APP_WEB_CLIENT_ID = var.APP_WEB_CLIENT_ID
        APP_S3_BUCKET_NAME = var.APP_S3_BUCKET_NAME
    }
}
