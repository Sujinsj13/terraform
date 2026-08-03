terraform {
  backend "s3" {
    bucket         = "github-backup-1"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
