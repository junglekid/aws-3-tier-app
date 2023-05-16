# aws-3-tier-app
## Use TerraForm to build the following:
* Lambda functions
* API Gateway
* API Gateway resources
* API Gateway deployments
* DynamoDB Tables and populate table
* IAM policies and roles
## Set tags in locals.tf
* tags
## Update variables in variables.tf
* tags
## Update S3 Backend in provider.tf
* bucket
* key
* profile
* dynamodb_table
## Run Terraform
```
terraform init
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```
## Test GET Request with API Gateway > Lambda > DynamoDB
```
API_KEY=$(terraform output -raw api_gateway_api_key)
API_URL=$(terraform output -raw url_get-shirt-color)
curl -sS -H "x-api-key: $API_KEY" "$API_URL" | jq
```
## Test POST Request with API Gateway > Lambda > DynamoDB
```
API_KEY=$(terraform output -raw api_gateway_api_key)
API_URL=$(terraform output -raw url_add-shirt-color)
curl -sS -X POST -H "x-api-key: $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{ "color": "Pink" }' \
  "$API_URL" | jq
```
## Clean up Terraform
```
terraform destroy
```
