# Staging Environment Configuration
aws_region    = "us-east-1"
project_name  = "superaws"
environment   = "staging"

# S3 Configuration
create_s3_bucket = true
s3_bucket_name   = "staging-data-bucket"

# EC2 Configuration
create_ec2_instance = true
instance_type       = "t3.small"

# Additional tags
additional_tags = {
  Owner       = "DevTeam"
  CostCenter  = "Engineering"
  BackupPolicy = "Daily"
  Monitoring  = "Enhanced"
}