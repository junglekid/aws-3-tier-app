# aws-3-tier-app
## Use TerraForm to build the following:
* Lambda functions
* API Gateway
* API Gateway resources
* API Gateway deployments
* DynamoDB Tables and populate table
* IAM policies and roles
## Set variables in variables.tf
* my_name
* tags
## Run Terraform
```
terraform init
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```
## Test API Gateway > Lambda > DynamoDB
```
aws sqs \
  --region <REGION> send-message \
  --queue-url <SQS_URL> \
  --message-body '{"number": <ANY_NUMBER>}'
API_KEY=$(terraform output -raw api_gateway_api_key)
API_URL=$(terraform output -raw url_get-shirt-color)
curl -sS -H "x-api-key: $API_KEY" "$API_URL" | jq
```
## Test API Gateway > Lambda > DynamoDB
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
