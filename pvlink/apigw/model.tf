# Models for request validation
resource "aws_api_gateway_model" "pet" {
  rest_api_id  = aws_api_gateway_rest_api.private_api_test.id
  name         = "Pet"
  description  = "Pet model"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object",
  "properties": {
    "id": {
      "type": "integer"
    },
    "type": {
      "type": "string"
    },
    "price": {
      "type": "number"
    }
  }
}
EOF
}

resource "aws_api_gateway_model" "new_pet" {
  rest_api_id  = aws_api_gateway_rest_api.private_api_test.id
  name         = "NewPet"
  description  = "NewPet model"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "enum": ["dog", "cat", "fish", "bird", "gecko"]
    },
    "price": {
      "type": "number"
    }
  }
}
EOF
}

resource "aws_api_gateway_model" "new_pet_response" {
  rest_api_id  = aws_api_gateway_rest_api.private_api_test.id
  name         = "NewPetResponse"
  description  = "NewPetResponse model"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object",
  "properties": {
    "pet": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.private_api_test.id}/models/Pet"
    },
    "message": {
      "type": "string"
    }
  }
}
EOF
}

resource "aws_api_gateway_model" "pets" {
  rest_api_id  = aws_api_gateway_rest_api.private_api_test.id
  name         = "Pets"
  description  = "Pets model"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "array",
  "items": {
    "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.private_api_test.id}/models/Pet"
  }
}
EOF
}
