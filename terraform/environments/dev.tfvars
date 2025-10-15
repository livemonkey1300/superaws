# Development Environment Configuration
aws_region    = "us-east-1"
project_name  = "superaws"
environment   = "dev"

# S3 Configuration
create_s3_bucket = true
s3_bucket_name   = "dev-data-bucket"

# EC2 Configuration
create_ec2_instance = false
instance_type       = "t3.micro"

# Additional tags
additional_tags = {
  Owner       = "DevTeam"
  CostCenter  = "Engineering"
  BackupPolicy = "Daily"
}