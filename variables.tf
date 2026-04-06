variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "us-east-1"
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

}

variable "instance_name" { 
  description = "Name tag for the EC2 instance"
  type        = string 
  default     = "TerraformLab-Dev"
}
