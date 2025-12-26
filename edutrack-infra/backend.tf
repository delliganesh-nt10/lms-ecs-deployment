terraform {
  backend "s3" {
    bucket         = "edutrack-terraform-state-2703"
    key            = "edutrack/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
