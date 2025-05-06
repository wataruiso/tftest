# Resources
resource "aws_api_gateway_resource" "pets" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  parent_id   = aws_api_gateway_rest_api.private_api_test.root_resource_id
  path_part   = "pets"
}

resource "aws_api_gateway_resource" "pet" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  parent_id   = aws_api_gateway_resource.pets.id
  path_part   = "{petId}"
}