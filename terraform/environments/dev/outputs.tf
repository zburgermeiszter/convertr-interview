output "api_endpoint" {
  description = "API Gateway endpoint URL for uploading pictures"
  value       = module.api_gateway.api_endpoint
}

output "api_id" {
  description = "API Gateway REST API ID"
  value       = module.api_gateway.api_id
}

output "api_stage_name" {
  description = "API Gateway stage name"
  value       = module.api_gateway.stage_name
}
output "s3_bucket_name" {
  description = "S3 bucket name for storing pictures"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.bucket_arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.lambda.function_arn
}

output "lambda_log_group_name" {
  description = "Lambda CloudWatch Log Group name"
  value       = module.lambda.log_group_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "s3_vpc_endpoint_id" {
  description = "S3 VPC Endpoint ID for IAM policy"
  value       = module.vpc.s3_vpc_endpoint_id
}
