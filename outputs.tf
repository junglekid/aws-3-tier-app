output "api_gateway_api_key" {
  value = aws_api_gateway_api_key.shirt_color.value
  sensitive = true
}

output "url_get-shirt-color" {
  value = "https://${aws_api_gateway_domain_name.shirt_color.domain_name}${aws_api_gateway_resource.get_shirt_color_resource.path}"
}

output "url_add-shirt-color" {
  value = "https://${aws_api_gateway_domain_name.shirt_color.domain_name}${aws_api_gateway_resource.add_shirt_color_resource.path}"
}
