locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
}

module "s3" {
  source = "../../modules/s3"

  name_prefix        = local.name_prefix
  s3_vpc_endpoint_id = module.vpc.s3_vpc_endpoint_id
}

module "lambda" {
  source = "../../modules/lambda"

  name_prefix             = local.name_prefix
  function_name           = "${local.name_prefix}-picture-uploader"
  lambda_dist_folder_path = "${path.root}/../../../lambda/dist"

  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_arn = module.s3.bucket_arn

  bucket_kms_key_arn = module.s3.bucket_kms_key_arn

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.lambda_security_group_id]

  environment_variables = {
    ENVIRONMENT : var.environment
  }
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  name_prefix     = local.name_prefix
  api_description = "${var.environment} API for picture upload"
  resource_path   = "upload"
  stage_name      = var.environment

  lambda_invoke_arn    = module.lambda.function_invoke_arn
  lambda_function_name = module.lambda.function_name
}
