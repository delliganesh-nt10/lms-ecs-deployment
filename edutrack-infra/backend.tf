terraform {
  backend "s3" {
    bucket         = "edutrack-terraform-state-0327"
    key            = "edutrack/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-infra-locks"
    encrypt        = true
  }
}
