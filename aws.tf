terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # This backend configuration instructs Terraform to store its state in an S3 bucket.
  backend "s3" {
    bucket         = "newsfit-state-locking-bucket-1104861342143743"       # Name of the S3 bucket where the state will be stored.
    key            = "terraform/terraform.tfstate"                         # Path within the bucket where the state will be read/written.
    region         = "ap-northeast-2"                                      # AWS region of the S3 bucket.
    dynamodb_table = "newsfit_state-locking-ddb_1928746237856237819482156" # DynamoDB table used for state locking.
    encrypt        = true                                                  # Ensures the state is encrypted at rest in S3.
  }
}

# Configuration for the AWS provider.
provider "aws" {
  region  = var.aws_region # AWS region where resources will be provisioned.
  profile = "newsfit"      # AWS CLI profile to use for authentication.
}
