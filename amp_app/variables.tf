variable "APP_IDENTITY_POOL_ID" {
    type = string
}
variable "APP_REGION" {
    type = string
}
variable "APP_USER_POOL_ID" {
    type = string
}
variable "APP_WEB_CLIENT_ID" {
    type = string
}
variable "APP_S3_BUCKET_NAME" {
    type = string
}
variable "REPOSITORY_URL" {
    type = string
}
variable "GITHUB_TOKEN" {
    type = string
    sensitive = true
}