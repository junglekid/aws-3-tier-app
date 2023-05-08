# Create the API Gateway
resource "aws_api_gateway_rest_api" "shirt_color_api" {
  name        = var.aws_api_gateway_rest_api_name
  description = var.aws_api_gateway_rest_api_description

  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create a resource for the API Gateway
resource "aws_api_gateway_resource" "get_shirt_color_resource" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  parent_id   = aws_api_gateway_rest_api.shirt_color_api.root_resource_id
  path_part   = var.aws_api_gateway_resource_get_part_part
}

resource "aws_api_gateway_resource" "add_shirt_color_resource" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  parent_id   = aws_api_gateway_rest_api.shirt_color_api.root_resource_id
  path_part   = var.aws_api_gateway_resource_add_part_part
}

# Create a method for the API Gateway
resource "aws_api_gateway_method" "get_shirt_color" {
  rest_api_id      = aws_api_gateway_rest_api.shirt_color_api.id
  resource_id      = aws_api_gateway_resource.get_shirt_color_resource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method_settings" "get_shirt_color" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  stage_name  = aws_api_gateway_stage.shirt_color.stage_name
  method_path = "*/*"

  settings {}
}

resource "aws_api_gateway_method" "add_shirt_color" {
  rest_api_id      = aws_api_gateway_rest_api.shirt_color_api.id
  resource_id      = aws_api_gateway_resource.add_shirt_color_resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method_settings" "add_shirt_color" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  stage_name  = aws_api_gateway_stage.shirt_color.stage_name
  method_path = "*/*"

  settings {}
}

# Create an integration between the API Gateway and Lambda function
resource "aws_api_gateway_integration" "get_shirt_color" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  resource_id = aws_api_gateway_resource.get_shirt_color_resource.id
  http_method = aws_api_gateway_method.get_shirt_color.http_method

  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.shirt_color.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "add_shirt_color" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id
  resource_id = aws_api_gateway_resource.add_shirt_color_resource.id
  http_method = aws_api_gateway_method.add_shirt_color.http_method

  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.shirt_color.invoke_arn
  integration_http_method = "POST"
}

# Create a deployment for the API Gateway and Lambda function
resource "aws_api_gateway_deployment" "shirt_color_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.shirt_color_api.id

  # Forces a new deployment each time the API Gateway changes
  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_api_gateway_rest_api.shirt_color_api),
      jsonencode(aws_api_gateway_resource.get_shirt_color_resource),
      jsonencode(aws_api_gateway_method.get_shirt_color),
      jsonencode(aws_api_gateway_integration.get_shirt_color)
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a stage for the API Gateway and Lambda function
resource "aws_api_gateway_stage" "shirt_color" {
  stage_name    = var.aws_api_gateway_stage_name
  rest_api_id   = aws_api_gateway_rest_api.shirt_color_api.id
  deployment_id = aws_api_gateway_deployment.shirt_color_api_deploy.id
}

# Create the API key
resource "aws_api_gateway_api_key" "shirt_color" {
  name = var.aws_api_gateway_api_key_name
}

# Add the API key to the usage plan
resource "aws_api_gateway_usage_plan" "shirt_color" {
  name        = var.aws_api_gateway_rest_usage_plan_name
  description = var.aws_api_gateway_rest_usage_plan_description

  api_stages {
    api_id = aws_api_gateway_rest_api.shirt_color_api.id
    stage  = aws_api_gateway_stage.shirt_color.stage_name
  }
}

# Associate the usage plan with the API key
resource "aws_api_gateway_usage_plan_key" "shirt_color" {
  key_id        = aws_api_gateway_api_key.shirt_color.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.shirt_color.id
}

resource "aws_api_gateway_domain_name" "shirt_color" {
  domain_name              = var.custom_domain_name
  regional_certificate_arn = aws_acm_certificate_validation.shirt_color.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "shirt_color" {
  api_id      = aws_api_gateway_rest_api.shirt_color_api.id
  stage_name  = aws_api_gateway_stage.shirt_color.stage_name
  domain_name = aws_api_gateway_domain_name.shirt_color.domain_name
}

# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "shirt_color" {
  name    = aws_api_gateway_domain_name.shirt_color.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.shirt_color.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.shirt_color.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.shirt_color.regional_zone_id
  }
}
