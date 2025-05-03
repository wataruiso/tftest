variable "vpc" {
  description = "Parameter for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet" {
  description = "Parameter for private subnet"
  type        = string
  default     = "10.0.128.0/24"
}

variable "default_instance_type" {
  default = "t2.micro"
}

variable "aws_id" {
  description = "AWS Account ID"
  type        = string
  sensitive   = true
}