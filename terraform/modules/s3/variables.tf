variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "allowed_origin" {
  description = "Allowed origin for CORS"
  type        = string
  default     = "*"
}
