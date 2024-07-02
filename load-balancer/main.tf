variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "lb_type" {
  description = "The type of the load balancer"
  type        = string
}

variable "is_external" {
  description = "Boolean to specify if the load balancer is external"
  type        = bool
  default     = false
}

variable "sg_enable_ssh_http" {
  description = "The security group ID that allows SSH and HTTP"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs"
  type        = list(string)
}

variable "tag_name" {
  description = "The tag name for the load balancer"
  type        = string
}

variable "lb_target_group_arn" {
  description = "The ARN of the load balancer target group"
  type        = string
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

variable "lb_listener_port" {
  description = "The port for the load balancer listener"
  type        = number
}

variable "lb_listener_protocol" {
  description = "The protocol for the load balancer listener"
  type        = string
}

variable "lb_listener_default_action" {
  description = "The default action for the load balancer listener"
  type        = string
}

variable "lb_target_group_attachment_port" {
  description = "The port for the load balancer target group attachment"
  type        = number
}
output "aws_lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.dev_proj_1_lb.dns_name
}

output "aws_lb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.dev_proj_1_lb.zone_id
}
resource "aws_lb" "dev_proj_1_lb" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_http]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.tag_name
  }
}

resource "aws_lb_target_group_attachment" "dev_proj_1_lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instance_id
  port             = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "dev_proj_1_lb_listener" {
  load_balancer_arn = aws_lb.dev_proj_1_lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = var.lb_target_group_arn
  }
}
