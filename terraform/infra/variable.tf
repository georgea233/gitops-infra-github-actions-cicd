variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-2"
}

variable "key_pair" {
  description = "The name of the SSH key pair to use for instances."
  type        = string
}

variable "security_groups" {
  description = "Map of security groups to create."
  type = map(object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "instances" {
  description = "Map of instances to create."
  type = map(object({
    name = string
    # environment    = string
    ami            = string
    instance_type  = string
    security_group = string
    user_data      = string
  }))
}

# variable "private_key_path" {
#   description = "The path to the SSH private key."
#   type        = string
#   default     = "~/.ssh/terraform-keypair.pem"
# }
