terraform {
  backend "s3" {
    bucket         = "github-backup-2"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
  }
}
