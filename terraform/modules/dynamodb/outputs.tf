output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.logs.arn
}

output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.logs.name
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = aws_dynamodb_table.logs.stream_arn
}