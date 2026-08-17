terraform {
  backend "s3" {
    bucket         = "vaultbridge-terraform-state-20260817"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "vaultbridge-terraform-lock"
    encrypt        = true
  }
}