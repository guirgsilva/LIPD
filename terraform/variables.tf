variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "website_bucket_name" {
  description = "Name of the S3 bucket for static website"
  type        = string
  default     = "lidp-static-website"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "greet-function"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "lidp-api"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "api-logs"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_origin" {
  description = "Allowed origin for CORS"
  type        = string
  default     = "*"
}