# Production Environment Configuration
aws_region    = "us-east-1"
project_name  = "superaws"
environment   = "prod"

# S3 Configuration
create_s3_bucket = true
s3_bucket_name   = "prod-data-bucket"

# EC2 Configuration
create_ec2_instance = true
instance_type       = "t3.medium"

# Additional tags
additional_tags = {
  Owner         = "ProdTeam"
  CostCenter    = "Engineering"
  BackupPolicy  = "Hourly"
  Monitoring    = "Enhanced"
  Compliance    = "SOC2"
}