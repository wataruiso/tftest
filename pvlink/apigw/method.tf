# Methods for root resource
resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_rest_api.private_api_test.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_rest_api.private_api_test.root_resource_id
  http_method = aws_api_gateway_method.root_get.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "root_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_rest_api.private_api_test.root_resource_id
  http_method = aws_api_gateway_method.root_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "root_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_rest_api.private_api_test.root_resource_id
  http_method = aws_api_gateway_method.root_get.http_method
  status_code = aws_api_gateway_method_response.root_get_response_200.status_code

  response_parameters = {
    "method.response.header.Content-Type" = "'text/html'"
  }

  response_templates = {
    "text/html" = <<EOF
<html>
    <head>
        <style>
        body {
            color: #333;
            font-family: Sans-serif;
            max-width: 800px;
            margin: auto;
        }
        </style>
    </head>
    <body>
        <h1>Welcome to your Pet Store API</h1>
        <p>
            You have successfully deployed your first API. You are seeing this HTML page because the <code>GET</code> method to the root resource of your API returns this content as a Mock integration.
        </p>
        <p>
            The Pet Store API contains the <code>/pets</code> and <code>/pets/{petId}</code> resources. By making a <a href="/$context.stage/pets/" target="_blank"><code>GET</code> request</a> to <code>/pets</code> you can retrieve a list of Pets in your API. If you are looking for a specific pet, for example the pet with ID 1, you can make a <a href="/$context.stage/pets/1" target="_blank"><code>GET</code> request</a> to <code>/pets/1</code>.
        </p>
        <p>
            You can use a REST client such as <a href="https://www.getpostman.com/" target="_blank">Postman</a> to test the <code>POST</code> methods in your API to create a new pet. Use the sample body below to send the <code>POST</code> request:
        </p>
        <pre>
{
    "type" : "cat",
    "price" : 123.11
}
        </pre>
    </body>
</html>
EOF
  }
}

# Methods for /pets resource
resource "aws_api_gateway_method" "pets_get" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_resource.pets.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.page" = false
    "method.request.querystring.type" = false
  }
}

resource "aws_api_gateway_integration" "pets_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_get.http_method
  type        = "HTTP"

  integration_http_method = "GET"
  uri                     = "http://petstore.execute-api.us-east-1.amazonaws.com/petstore/pets"

  request_parameters = {
    "integration.request.querystring.page" = "method.request.querystring.page"
    "integration.request.querystring.type" = "method.request.querystring.type"
  }
}

resource "aws_api_gateway_method_response" "pets_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "pets_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_get.http_method
  status_code = aws_api_gateway_method_response.pets_get_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "pets_post" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_resource.pets.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "pets_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_post.http_method
  type        = "HTTP"

  integration_http_method = "POST"
  uri                     = "http://petstore.execute-api.us-east-1.amazonaws.com/petstore/pets"
}

resource "aws_api_gateway_method_response" "pets_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "pets_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_post.http_method
  status_code = aws_api_gateway_method_response.pets_post_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# OPTIONS method for CORS
resource "aws_api_gateway_method" "pets_options" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_resource.pets.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "pets_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "pets_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "pets_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pets.id
  http_method = aws_api_gateway_method.pets_options.http_method
  status_code = aws_api_gateway_method_response.pets_options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"
  }
}

# Methods for /pets/{petId} resource
resource "aws_api_gateway_method" "pet_get" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_resource.pet.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.petId" = true
  }
}

resource "aws_api_gateway_integration" "pet_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_get.http_method
  type        = "HTTP"

  integration_http_method = "GET"
  uri                     = "http://petstore.execute-api.us-east-1.amazonaws.com/petstore/pets/{petId}"

  request_parameters = {
    "integration.request.path.petId" = "method.request.path.petId"
  }
}

resource "aws_api_gateway_method_response" "pet_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "pet_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_get.http_method
  status_code = aws_api_gateway_method_response.pet_get_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# OPTIONS method for CORS
resource "aws_api_gateway_method" "pet_options" {
  rest_api_id   = aws_api_gateway_rest_api.private_api_test.id
  resource_id   = aws_api_gateway_resource.pet.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.petId" = true
  }
}

resource "aws_api_gateway_integration" "pet_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "pet_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "pet_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.private_api_test.id
  resource_id = aws_api_gateway_resource.pet.id
  http_method = aws_api_gateway_method.pet_options.http_method
  status_code = aws_api_gateway_method_response.pet_options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"
  }
}
