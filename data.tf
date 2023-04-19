# Retrieve data AWS Route53 Zone
data "aws_route53_zone" "shirt_color" {
  name         = var.aws_route53_zone_name
  private_zone = false
}

# Create Lambda Function Zip archive
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda/app.py"
  output_path = var.aws_lambda_function_filename
}
