output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.APP-VPC.id
}

output "public_subnet_ids" {
  description = "List of IDs for public subnets"
  value       = aws_subnet.public-subnets[*].id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.rt-table.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sg-1.id
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

output "launch_template_id" {
  description = "The ID of the Launch Template"
  value       = aws_launch_template.launch-temp.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb1.dns_name
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.alb-target.arn
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.alb-listener.arn
}
