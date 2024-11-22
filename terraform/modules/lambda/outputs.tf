# modules/lambda/outputs.tf

output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.greet.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.greet.invoke_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.greet.function_name
}

output "function_url" {
  description = "URL of the Lambda function"
  value       = aws_lambda_function_url.url.function_url  
}