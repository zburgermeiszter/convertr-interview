variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "api_description" {
  description = "API Gateway description"
  type        = string
  default     = "API Gateway for Lambda integration"
}

variable "binary_media_types" {
  description = "List of binary media types supported by the REST API"
  type        = list(string)
  default = [
    "image/jpeg",
    "image/jpg",
    "image/png",
    "image/gif",
    "image/webp",
  ]
}

variable "resource_path" {
  description = "API resource path"
  type        = string
  default     = "upload"
}

variable "lambda_invoke_arn" {
  description = "Lambda function invoke ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "dev"
}

variable "access_log_format" {
  description = "Access log format"
  type        = string
  default     = "$context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime]\"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId $context.extendedRequestId"
}


variable "logging_level" {
  description = "Logging level for API Gateway"
  type        = string
  default     = "INFO"
  validation {
    condition     = contains(["OFF", "ERROR", "INFO"], var.logging_level)
    error_message = "Logging level must be OFF, ERROR, or INFO."
  }
}
