# modules/dynamodb/main.tf

# KMS Key for DynamoDB encryption
resource "aws_kms_key" "dynamodb_key" {
  description             = "KMS key for DynamoDB table encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  tags = {
    Environment = var.environment
  }
}

resource "aws_kms_alias" "dynamodb_key_alias" {
  name          = "alias/${var.table_name}-key"
  target_key_id = aws_kms_key.dynamodb_key.key_id
}

# DynamoDB Table
resource "aws_dynamodb_table" "logs" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  global_secondary_index {
    name               = "TimeStampIndex"  # Nome corrigido
    hash_key           = "timestamp"
    projection_type    = "ALL"
    read_capacity      = 5    # Valores mínimos para LocalStack
    write_capacity     = 5    # Valores mínimos para LocalStack
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }

  tags = {
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = false  # Permitir destruição para testes
  }
}

# CloudWatch Alarms for DynamoDB
resource "aws_cloudwatch_metric_alarm" "dynamodb_throttled_requests" {
  alarm_name          = "${var.table_name}-throttled-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "DynamoDB throttled requests"
  alarm_actions       = []

  dimensions = {
    TableName = aws_dynamodb_table.logs.name
  }

  tags = {
    Environment = var.environment
  }
}