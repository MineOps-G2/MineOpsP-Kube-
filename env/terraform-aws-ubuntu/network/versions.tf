terraform {
  required_version = "~> 1.3.0"  # error) Unsupported Terraform Core version 에러로 버전 수정 required_version = "~> 1.0.0" d

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
