
#Frontend Target Group
resource "aws_lb_target_group" "frontend_target_group" {
  name        = "devops-fe-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}

#Backend Target Group
resource "aws_lb_target_group" "backend_target_group" {
  name        = "devops-be-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/api/students"
    protocol            = "HTTP"
    port                = "8080"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}
#Application Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "udemy-devops-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.load_balance_security_group_ids
  subnets            = var.load_balance_subnet_ids
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "udemy-devops-alb"
  }
}

#Load Balancer Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}
# Custom rule for /api/*
resource "aws_lb_listener_rule" "backend_api_rule" {
  listener_arn = "${aws_lb_listener.listener.arn}"
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.backend_target_group.arn}"
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
