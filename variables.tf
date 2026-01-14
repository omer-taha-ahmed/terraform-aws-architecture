variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "instance_count" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 2
}

variable "database_name" {
  description = "RDS database name"
  type        = string
  default     = "myappdb"
}

variable "allocated_storage" {
  description = "RDS storage in GB"
  type        = number
  default     = 20
}
