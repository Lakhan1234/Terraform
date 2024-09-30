terraform {
  required_providers {
      aws = {
                source = "hashicorp/aws"
	             version = "5.69.0"
            }
		      }
        }

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA6PMINCCM3BXMIWGZ"
  secret_key = "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"
}
