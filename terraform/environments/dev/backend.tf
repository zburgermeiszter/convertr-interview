terraform {
  required_version = ">= 1.13.3"

  backend "s3" {
    bucket       = "092258629944-tf-state-bucket"
    encrypt      = true
    key          = "convertr/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
