variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "s3_vpc_endpoint_id" {
  description = "S3 VPC Endpoint ID for IAM policy"
  type        = string
  default     = ""
}