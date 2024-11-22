provider "aws" {
  region = "us-east-1"
  
  # LocalStack specific configurations
  skip_credentials_validation = true
  skip_metadata_api_check    = true
  skip_requesting_account_id = true
  skip_region_validation     = true
  s3_use_path_style         = true
  
  # Default credentials
  access_key = "test"
  secret_key = "test"
  
  # Increase retry attempts
  max_retries = 10
  
  # Default LocalStack endpoint
  endpoints {
    apigateway   = "http://localhost:4566"
    cloudwatch   = "http://localhost:4566"
    dynamodb     = "http://localhost:4566"
    ec2          = "http://localhost:4566"
    iam          = "http://localhost:4566"
    kms          = "http://localhost:4566"
    lambda       = "http://localhost:4566"
    logs         = "http://localhost:4566"
    s3           = "http://localhost:4566"
    sns          = "http://localhost:4566"
    sqs          = "http://localhost:4566"
    cognitoidp   = "http://localhost:4566"
  }
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# Random string para garantir nomes únicos
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# DynamoDB Module
module "dynamodb" {
  source = "./modules/dynamodb"
  
  table_name  = "${var.dynamodb_table_name}-${random_string.suffix.result}"
  environment = var.environment
}

# Lambda Module
module "lambda_function" {
  source = "./modules/lambda"
  
  function_name       = "${var.lambda_function_name}-${random_string.suffix.result}"
  environment        = var.environment
  dynamodb_table_name = module.dynamodb.table_name
  dynamodb_table_arn  = module.dynamodb.table_arn

  depends_on = [
    module.dynamodb
  ]
}

# API Gateway Module
module "api_gateway" {
  source = "./modules/api_gateway"
  
  api_name            = "${var.api_name}-${random_string.suffix.result}"
  environment         = var.environment
  lambda_invoke_arn   = module.lambda_function.lambda_invoke_arn
  lambda_function_name = module.lambda_function.function_name

  depends_on = [
    module.lambda_function
  ]
}

# S3 Module for Static Website
module "static_website" {
  source = "./modules/s3"
  
  bucket_name     = "${var.website_bucket_name}-${random_string.suffix.result}"
  environment     = var.environment
  allowed_origin  = var.allowed_origin

  depends_on = [
    module.api_gateway
  ]
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "LIDP-Cloud-Challenge-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiName", module.api_gateway.api_id],
            ["AWS/ApiGateway", "4XXError", "ApiName", module.api_gateway.api_id],
            ["AWS/ApiGateway", "5XXError", "ApiName", module.api_gateway.api_id]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "API Gateway Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", module.lambda_function.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", module.lambda_function.function_name],
            ["AWS/Lambda", "Duration", "FunctionName", module.lambda_function.function_name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Lambda Metrics"
        }
      }
    ]
  })
}

# SNS Topic para alertas
resource "aws_sns_topic" "alerts" {
  name = "cloud-challenge-alerts-${var.environment}"
}