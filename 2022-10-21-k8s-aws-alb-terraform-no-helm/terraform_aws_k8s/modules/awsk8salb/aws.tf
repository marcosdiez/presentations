variable "hostname" {
  type = string
}

output "hostname" {
  value = var.hostname
}

variable "aws_lb_name" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "alb_listener_port" {
  default = 443
}

data "aws_lb" "k8salb" {
  name = var.aws_lb_name
}

data "aws_lb_listener" "default" {
  load_balancer_arn = data.aws_lb.k8salb.arn
  port              = var.alb_listener_port
}

resource "aws_route53_record" "alb_dns_entry" {
  zone_id = var.route53_zone_id
  name    = var.hostname
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.k8salb.dns_name]
}

resource "aws_lb_target_group" "k8s_tg" {
  name        = substr("k8s-${var.k8s_deployment_name}", 0, 28)
  port        = var.container_listener_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_lb.k8salb.vpc_id

  tags = {
    "K8sInfo" = "This TG sends sends data to K8S Pods. The targets are managed by the K8S AWS ALB Controller"
  }
}

resource "aws_lb_listener_rule" "k8s_rule" {
  listener_arn = data.aws_lb_listener.default.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_tg.arn
  }

  condition {
    host_header {
      values = [var.hostname]
    }
  }
}