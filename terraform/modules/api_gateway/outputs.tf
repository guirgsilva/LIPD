output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = "${aws_api_gateway_stage.api.invoke_url}/greet"
}

output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.api_pool.id
}

output "cognito_app_client_id" {
  description = "Cognito App Client ID"
  value       = aws_cognito_user_pool_client.api_client.id
}