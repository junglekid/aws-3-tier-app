# Create a DynamoDB table with server-side encryption
resource "aws_dynamodb_table" "shirt_color" {
  name           = var.aws_dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Color"

  attribute {
    name = "Color"
    type = "S"
  }
}

# Create an IAM policy for the Lambda function to access the DynamoDB table
resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = var.aws_iam_policy_dynamodb_access_policy_name
  description = "A policy to allow access to DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.shirt_color.arn
      }
    ]
  })
}

# Attach the IAM policy to the Lambda function's execution role
resource "aws_iam_role_policy_attachment" "dynamodb_access_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

# Populate DynamoDB Table
resource "aws_dynamodb_table_item" "shirt_color" {
  for_each = toset(local.shirt_colors)

  table_name = aws_dynamodb_table.shirt_color.name
  hash_key   = aws_dynamodb_table.shirt_color.hash_key

  item = jsonencode({
     "Color" : {
      "S" : each.key
    },
  })
}
