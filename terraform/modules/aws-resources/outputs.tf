output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.main[0].id : null
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.main[0].arn : null
}

output "ec2_instance_id" {
  description = "ID of the created EC2 instance"
  value       = var.create_ec2_instance ? aws_instance.main[0].id : null
}

output "ec2_instance_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = var.create_ec2_instance ? aws_instance.main[0].public_ip : null
}

output "security_group_id" {
  description = "ID of the security group"
  value       = var.create_ec2_instance ? aws_security_group.ec2[0].id : null
}