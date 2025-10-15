terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: Configure remote state backend
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "superaws/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Call the submodule
module "superaws_resources" {
  source = "./modules/aws-resources"
  
  # Pass variables to the submodule
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  
  # Example resource configurations
  create_s3_bucket    = var.create_s3_bucket
  s3_bucket_name      = var.s3_bucket_name
  create_ec2_instance = var.create_ec2_instance
  instance_type       = var.instance_type
  
  # Additional tags to pass to resources
  additional_tags = var.additional_tags
}