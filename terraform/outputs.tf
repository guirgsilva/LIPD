output "website_url" {
  description = "URL of the static website"
  value       = module.static_website.website_url
}

output "cloudfront_url" {
  description = "CloudFront Distribution URL"
  value       = module.static_website.cloudfront_url
}

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = module.api_gateway.api_endpoint
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.api_gateway.cognito_user_pool_id
}

output "cognito_app_client_id" {
  description = "Cognito App Client ID"
  value       = module.api_gateway.cognito_app_client_id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_function.function_name
}