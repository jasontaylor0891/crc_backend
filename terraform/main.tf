terraform {
  backend "s3" {
    bucket = "terraform-state-cloud-resume-challenge-backend"
    key    = "backend-terraform.tfstate"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}