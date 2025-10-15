output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.superaws_resources.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.superaws_resources.s3_bucket_arn
}

output "ec2_instance_id" {
  description = "ID of the created EC2 instance"
  value       = module.superaws_resources.ec2_instance_id
}

output "ec2_instance_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = module.superaws_resources.ec2_instance_public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.superaws_resources.vpc_id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = module.superaws_resources.subnet_id
}