output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_kms_key_arn" {
  description = "KMS key ARN for bucket encryption"
  value       = aws_kms_key.encryption.arn
}
