# SuperAWS - Terraform Infrastructure as Code

A comprehensive Terraform setup with modular architecture and automated CI/CD via GitHub Actions.

## 🏗️ Architecture

This repository provides a scalable Terraform infrastructure with:

- **Modular Design**: Reusable Terraform submodules for AWS resources
- **Multi-Environment Support**: Separate configurations for dev, staging, and production
- **Automated CI/CD**: GitHub Actions workflow for infrastructure deployment
- **Best Practices**: Security, tagging, and resource management

## 📁 Project Structure

```
├── .github/
│   └── workflows/
│       └── terraform.yml          # GitHub Actions CI/CD workflow
├── terraform/
│   ├── main.tf                    # Main Terraform configuration
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── terraform.tfvars.example   # Example variables file
│   ├── environments/              # Environment-specific configurations
│   │   ├── dev.tfvars
│   │   ├── staging.tfvars
│   │   └── prod.tfvars
│   └── modules/
│       └── aws-resources/         # Reusable AWS resources module
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── .gitignore                     # Git ignore patterns
```

## 🚀 Quick Start

### 1. Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- GitHub repository with Actions enabled

### 2. Local Development Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd superaws

# Navigate to terraform directory
cd terraform

# Copy and customize the example variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your specific values

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file="environments/dev.tfvars"

# Apply (if plan looks good)
terraform apply -var-file="environments/dev.tfvars"
```

### 3. GitHub Actions Setup

#### Required Secrets

Configure these secrets in your GitHub repository settings:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

#### Optional Variables

- `AWS_REGION`: Default AWS region (defaults to us-east-1)

## 🛠️ Module Features

### AWS Resources Module

The `modules/aws-resources` module provides:

- **VPC**: Virtual Private Cloud with public subnet
- **S3 Bucket**: Versioned, encrypted storage with security best practices
- **EC2 Instance**: Optional compute instance with security group
- **Security Group**: Configured for HTTP/HTTPS/SSH access
- **Key Pair**: For EC2 SSH access (when enabled)

### Configuration Options

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for resources | `us-east-1` | No |
| `project_name` | Name of the project | `superaws` | No |
| `environment` | Environment (dev/staging/prod) | `dev` | No |
| `create_s3_bucket` | Whether to create S3 bucket | `true` | No |
| `s3_bucket_name` | S3 bucket name suffix | `data-bucket` | No |
| `create_ec2_instance` | Whether to create EC2 instance | `false` | No |
| `instance_type` | EC2 instance type | `t3.micro` | No |
| `additional_tags` | Extra tags for all resources | `{}` | No |

## 🔄 GitHub Actions Workflow

The workflow is triggered by:

1. **Push to main/master**: Automatic plan and apply
2. **Pull Request**: Plan only with PR comment
3. **Manual Dispatch**: Choose plan/apply/destroy with environment selection

### Workflow Features

- **Format Check**: Ensures consistent code formatting
- **Security**: Uses AWS credentials from GitHub secrets
- **Multi-Environment**: Deploy to dev, staging, or production
- **PR Comments**: Automatic plan results in pull requests
- **Manual Control**: Workflow dispatch for manual operations

### Manual Deployment

You can manually trigger deployments:

1. Go to Actions tab in GitHub
2. Select "Terraform CI/CD" workflow
3. Click "Run workflow"
4. Choose action (plan/apply/destroy) and environment

## 🏷️ Resource Tagging

All resources are automatically tagged with:

- `Project`: Project name
- `Environment`: Environment name
- `ManagedBy`: "Terraform"
- Additional custom tags via `additional_tags` variable

## 🔒 Security Best Practices

- S3 buckets have public access blocked by default
- Server-side encryption enabled for S3
- Security groups follow least privilege principle
- Versioning enabled on S3 buckets
- State file should be stored remotely (S3 backend recommended)

## 🌍 Multi-Environment Management

Each environment has its own configuration file:

- `dev.tfvars`: Development environment (minimal resources)
- `staging.tfvars`: Staging environment (moderate resources)
- `prod.tfvars`: Production environment (full resources)

Example deployment to staging:
```bash
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

## 📝 Outputs

After successful deployment, you'll get:

- S3 bucket name and ARN
- EC2 instance ID and public IP (if created)
- VPC and subnet IDs
- Security group ID

## 🧹 Cleanup

To destroy resources:

```bash
# Local cleanup
terraform destroy -var-file="environments/dev.tfvars"

# Or use GitHub Actions
# Go to Actions → Run workflow → Select "destroy"
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📚 Additional Resources

- [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Provider Reference](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## ⚠️ Important Notes

- Always review `terraform plan` output before applying
- Store Terraform state remotely in production
- Use different AWS accounts for different environments
- Regular backup your state files
- Monitor AWS costs and set up billing alerts

---

**Happy Infrastructure as Coding! 🚀**
