variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "superaws"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "create_s3_bucket" {
  description = "Whether to create an S3 bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket (will be prefixed with project and environment)"
  type        = string
  default     = "data-bucket"
}

variable "create_ec2_instance" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}