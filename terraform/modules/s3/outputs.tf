output "website_url" {
  description = "URL of the static website"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "bucket_name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.website.arn
}