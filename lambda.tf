# Create a Lambda function
resource "aws_lambda_function" "shirt_color" {
  function_name = var.aws_lambda_function_name
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  filename      = var.aws_lambda_function_filename
  role          = aws_iam_role.lambda_execution_role.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.shirt_color.name
    }
  }
}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name = var.aws_iam_role_lambda_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "shirt_color" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shirt_color.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.shirt_color_api.execution_arn}/*/*"
}
