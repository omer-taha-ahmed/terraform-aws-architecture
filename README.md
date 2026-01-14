# Terraform AWS Multi-Tier Web Application Architecture

## Overview

This project demonstrates a complete cloud architecture for a scalable web application with:
- **Multi-AZ High Availability** across availability zones
- **Auto-scaling** compute infrastructure
- **Secure networking** with VPC, subnets, and security groups
- **Load balancing** for traffic distribution
- **Infrastructure-as-Code** (IaC) for repeatable deployments
- **Cost optimization** through smart resource management

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Internet Gateway                    │
└────────────────────┬────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼──────┐        ┌────────▼──────┐
│   ALB (AZ1)  │        │   ALB (AZ2)   │
└───────┬──────┘        └────────┬──────┘
        │                         │
   ┌────┴────┐              ┌────┴────┐
   │          │              │         │
┌──▼──┐   ┌──▼──┐        ┌──▼──┐  ┌──▼──┐
│ EC2 │   │ EC2 │        │ EC2 │  │ EC2 │
└─────┘   └─────┘        └─────┘  └─────┘
   │          │              │        │
   └──────────┴──────────────┴────────┘
              │
        ┌─────▼─────┐
        │ RDS Multi │
        │    -AZ    │
        └───────────┘
```

## Key Features

### High Availability
- Multi-AZ deployment across 2+ availability zones
- Auto Scaling Group (ASG) for dynamic scaling
- Application Load Balancer (ALB) for traffic distribution
- RDS Multi-AZ for database failover

### Security
- VPC with public/private subnets
- Security groups with least-privilege rules
- IAM roles for EC2 instances
- Encrypted RDS database
- Secrets management for sensitive data

### Scalability
- Auto Scaling policies (CPU-based, memory-based)
- Dynamic instance provisioning
- Load balancing across multiple instances
- RDS read replicas ready

### Cost Optimization
- Right-sized EC2 instances (t3.medium default)
- Storage lifecycle policies
- Automated cleanup of unused resources
- Cost monitoring via CloudWatch

## Project Structure

```
terraform-aws-architecture/
├── main.tf              # Primary Terraform configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── vpc.tf               # VPC and networking
├── security.tf          # Security groups and IAM
├── compute.tf           # EC2 and Auto Scaling
├── database.tf          # RDS configuration
├── monitoring.tf        # CloudWatch and alarms
├── terraform.tfvars     # Variable values (create this)
├── .gitignore           # Exclude sensitive files
└── README.md            # This file
```

## Prerequisites

Before you begin, ensure you have:
- AWS Account with appropriate permissions
- Terraform >= 1.0 installed
- AWS CLI configured with credentials
- SSH key pair created in AWS (for EC2 access)

## Installation & Deployment

### 1. Clone the repository
```bash
git clone https://github.com/omer-taha/terraform-aws-architecture.git
cd terraform-aws-architecture
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Create terraform.tfvars
```hcl
aws_region          = "us-east-1"
environment         = "production"
instance_count      = 2
instance_type       = "t3.medium"
database_name       = "myappdb"
allocated_storage   = 20
```

### 4. Validate configuration
```bash
terraform validate
terraform plan
```

### 5. Deploy infrastructure
```bash
terraform apply
```

### 6. Retrieve outputs
```bash
terraform output
# Outputs include:
# - Load Balancer DNS
# - RDS Endpoint
# - Auto Scaling Group Name
```

## Configuration

### Variables (terraform.tfvars)

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | us-east-1 |
| `environment` | Environment name | production |
| `instance_type` | EC2 instance type | t3.medium |
| `instance_count` | Min instances | 2 |
| `max_instances` | Max ASG size | 4 |
| `db_instance_class` | RDS instance type | db.t3.micro |
| `allocated_storage` | RDS storage (GB) | 20 |

### Auto Scaling Policies

- **Scale Up:** CPU > 70% for 2 minutes
- **Scale Down:** CPU < 30% for 5 minutes
- **Min Instances:** 2
- **Max Instances:** 4

### Networking

- **VPC CIDR:** 10.0.0.0/16 (customizable)
- **Public Subnets:** 10.0.1.0/24, 10.0.2.0/24
- **Private Subnets:** 10.0.10.0/24, 10.0.11.0/24
- **RDS Subnet Group:** Private subnets only

## Monitoring & Logging

CloudWatch metrics and alarms are automatically created:
- CPU Utilization
- Network In/Out
- Disk I/O
- Database connections
- Custom application metrics

View logs:
```bash
aws logs tail /aws/ec2/app --follow
aws logs tail /aws/rds/mysql --follow
```

## Cleanup

To destroy all resources and avoid AWS charges:
```bash
terraform destroy
```

**Important:** Review resources before destroying. Ensure no production data is lost.

## Scaling & Performance

### Estimated Performance
- **Uptime:** ~99.8% (Multi-AZ)
- **Requests/sec:** 1000+ (with proper app optimization)
- **Database Connections:** 100+
- **Failover Time:** < 5 minutes

### Cost Estimate (us-east-1)
- 2 x t3.medium EC2: ~$30/month
- RDS Multi-AZ: ~$50/month
- Load Balancer: ~$16/month
- **Total:** ~$96/month (varies by region)

## Security Best Practices Implemented

✅ Least-privilege IAM policies  
✅ VPC with public/private subnets  
✅ Security groups for micro-segmentation  
✅ Encrypted RDS (KMS encryption ready)  
✅ Secrets stored outside code (use AWS Secrets Manager)  
✅ CloudTrail logging (audit trail)  
✅ VPC Flow Logs (network monitoring)  

## Troubleshooting

### Instances not launching
```bash
# Check Auto Scaling Group
aws autoscaling describe-auto-scaling-groups

# Check launch configuration
aws ec2 describe-launch-templates
```

### Database connection failures
```bash
# Verify RDS security group
aws ec2 describe-security-groups --group-ids sg-xxxxx

# Test connectivity from EC2
mysql -h <rds-endpoint> -u admin -p
```

### Load Balancer not routing traffic
```bash
# Check target health
aws elbv2 describe-target-health --target-group-arn arn:xxx
```

## Learning Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/language/values/locals.html)


## 👤 Author

**Omer Taha**  
Cloud Engineer | AWS Solutions Architect Professional | CKAD  
LinkedIn: [linkedin.com/in/omar-taha-ah](https://linkedin.com/in/omar-taha-ah)

---

**Last Updated:** January 2026  
**Terraform Version:** >= 1.0  
**AWS Region Tested:** us-east-1, eu-west-1
