variable "pj_name" {}
variable "endpoint_id" {}

resource "aws_api_gateway_rest_api" "private_api_test" {
  name        = "private_api_test"
  description = "Private API for testing"
  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = [var.endpoint_id]
  }
  tags = {
    Name = var.pj_name
  }
}

