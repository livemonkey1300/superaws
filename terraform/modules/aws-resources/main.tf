terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    },
    var.additional_tags
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-igw"
    },
    var.additional_tags
  )
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-public-subnet"
    },
    var.additional_tags
  )
}

# Create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
    },
    var.additional_tags
  )
}

# Associate route table with subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for EC2
resource "aws_security_group" "ec2" {
  count       = var.create_ec2_instance ? 1 : 0
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  # SSH access (restrict this in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-ec2-sg"
    },
    var.additional_tags
  )
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = "${var.project_name}-${var.environment}-${var.s3_bucket_name}-${random_id.bucket_suffix[0].hex}"

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-${var.s3_bucket_name}"
    },
    var.additional_tags
  )
}

# Random ID for bucket suffix to ensure uniqueness
resource "random_id" "bucket_suffix" {
  count       = var.create_s3_bucket ? 1 : 0
  byte_length = 4
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "main" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.main[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "main" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# EC2 Key Pair (you'll need to provide the public key)
resource "aws_key_pair" "main" {
  count      = var.create_ec2_instance ? 1 : 0
  key_name   = "${var.project_name}-${var.environment}-keypair"
  public_key = var.ec2_public_key != "" ? var.ec2_public_key : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7S7geVVV... # Replace with your public key"

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-keypair"
    },
    var.additional_tags
  )
}

# EC2 Instance
resource "aws_instance" "main" {
  count                  = var.create_ec2_instance ? 1 : 0
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.main[0].key_name
  vpc_security_group_ids = [aws_security_group.ec2[0].id]
  subnet_id             = aws_subnet.public.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ${var.project_name}-${var.environment}!</h1>" > /var/www/html/index.html
              EOF

  tags = merge(
    {
      Name = "${var.project_name}-${var.environment}-instance"
    },
    var.additional_tags
  )
}