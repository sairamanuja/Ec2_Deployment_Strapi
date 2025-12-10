variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Local public key path (optional)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "dockerhub_image" {
  description = "Docker Hub image (user/repo:tag)"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_filter_name" {
  description = "Ubuntu AMI filter"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}
