variable aws_region {
  type        = string
  description = "AWS Region to use"
  default     = "us-west-2"
}

variable aws_profile {
  type        = string
  description = "AWS Profile to use"
  default     = "bsisandbox"
}

variable custom_domain_name {
  type        = string
  description = "Custom Domain Name to use with API Gateway"
  default     = "shirt-color-api.bsisandbox.com"
}

variable aws_route53_zone_name {
  type        = string
  description = "AWS Route43 Zone name"
  default     = "bsisandbox.com"
}

variable aws_api_gateway_rest_api_name {
  type        = string
  description = "AWS API Gateway Name"
  default     = "shirt-color-api"
}

variable aws_api_gateway_rest_api_description {
  type        = string
  description = "AWS API Gateway Description"
  default     = "Shirt Color API"
}

variable aws_api_gateway_resource_get_part_part {
  type        = string
  description = "AWS API Gateway Resource Path Part"
  default     = "get-shirt-color"
}

variable aws_api_gateway_resource_add_part_part {
  type        = string
  description = "AWS API Gateway Resource Path Part"
  default     = "add-shirt-color"
}

variable aws_api_gateway_stage_name {
  type        = string
  description = "AWS API Gateway Stage Name"
  default     = "v1"
}

variable aws_api_gateway_api_key_name {
  type        = string
  description = "AWS API Gateway API Key Name"
  default     = "shirt-color-api-key"
}

variable aws_api_gateway_rest_usage_plan_name {
  type        = string
  description = "AWS API Gateway Usage Plan Name"
  default     = "shirt-color-usage-plan"
}

variable aws_api_gateway_rest_usage_plan_description {
  type        = string
  description = "AWS API Gateway Usage Plan Description"
  default     = "A shirt-color usage plan"
}

variable aws_lambda_function_name {
  type        = string
  description = "AWS Lambda Function Name"
  default     = "random-shirt-color"
}

variable aws_lambda_function_filename {
  type        = string
  description = "AWS Lambda Function File Name"
  default     = "lambda_function_payload.zip"
}

variable aws_iam_role_lambda_execution_role_name {
  type        = string
  description = "AWS IAM Role Lambda Execution Role Name"
  default     = "shirt_color_lambda_execution_role"
}

variable aws_lambda_permission_get_shirt_color_statement_id {
  type        = string
  description = "AWS Lambda Permission Get Shirt Color Statement Id"
  default     = "AllowExecutionFromAPIGatewaygetshirtcolor"
}

variable aws_lambda_permission_add_shirt_color_statement_id {
  type        = string
  description = "AWS Lambda Permission Add Shirt Color Statement Id"
  default     = "AllowExecutionFromAPIGatewayaddshirtcolor"
}

variable aws_dynamodb_table_name {
  type        = string
  description = "AWS DynamoDB Table Name"
  default     = "shirt-color-table"
}

variable aws_iam_policy_dynamodb_access_policy_name {
  type        = string
  description = "AWS IAM Policy Name for DynamoDB"
  default     = "dynamodb-access-policy"
}
