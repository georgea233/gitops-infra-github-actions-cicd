output "key_pair_name" {
  description = "The name of the SSH key pair"
  value       = var.key_pair
}

output "security_group_ids" {
  description = "The IDs of the security groups created"
  value       = { for sg in aws_security_group.security_groups : sg.id => sg.name }
}

output "instance_ids" {
  description = "The IDs of the instances created"
  value       = { for id, instance in aws_instance.ec2_instances : id => instance.id }
}

output "instance_public_ips" {
  description = "The public IPs of the instances created"
  value       = { for id, instance in aws_instance.ec2_instances : id => instance.public_ip }
}

output "instance_private_ips" {
  description = "The private IPs of the instances created"
  value       = { for id, instance in aws_instance.ec2_instances : id => instance.private_ip }
}

output "ami_ids" {
  description = "The AMI IDs used for the instances"
  value = {
    amazon_linux = data.aws_ami.amazon_linux.id
    ubuntu       = data.aws_ami.ubuntu.id
  }
}
