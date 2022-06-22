resource "aws_security_group" "sg-1" {
  name        = "${var.project}-${var.env}-alb-sg-1"
  description = "Security group for ALB to communicate in and out"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.project}-${var.env}-alb-sg-1"
    Environment = var.env
  }
}

resource "aws_alb" "alb-1" {
  name            = "${var.project}-${var.env}-alb-1"
  internal        = false
  security_groups = [aws_security_group.sg-1.id]
  subnets         = var.subnet_ids

  lifecycle {
    ignore_changes = [
      security_groups,
      tags
    ]
  }

  tags = {
    Name                       = "${var.project}-${var.env}-alb-1"
    "environment"              = var.env
    # add tags for alb-ingress auto discovery
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = var.env
    "elbv2.k8s.aws/cluster"    = var.cluster_name
  }
}

resource "aws_lb" "nlb-1" {
  name               = "${var.project}-${var.env}-nlb-1"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.subnet_ids
  tags               = {
    Name        = "${var.project}-${var.env}-nlb-1"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "tg-80" {
  name        = "${var.project}-${var.env}-tg-80"
  port        = 80
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "tg-443" {
  name        = "${var.project}-${var.env}-tg-443"
  port        = 443
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener-80" {
  load_balancer_arn = aws_lb.nlb-1.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-80.arn
  }
}

resource "aws_lb_listener" "listener-443" {
  load_balancer_arn = aws_lb.nlb-1.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-443.arn
  }
}

resource "aws_alb_listener" "https-listener" {
  load_balancer_arn = aws_alb.alb-1.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  lifecycle {
    # ignore changes, since we're using alb-ingress-controller
    ignore_changes = [
      ssl_policy,
      tags,
      tags_all,
      default_action
    ]
  }

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_alb_listener" "http-listener" {
  load_balancer_arn = aws_alb.alb-1.arn
  port              = "80"
  protocol          = "HTTP"

  lifecycle {
    # ignore changes, since we're using alb-ingress-controller
    ignore_changes = [
      tags,
      tags_all,
      default_action
    ]
  }

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# More details: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetDescription.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
resource "aws_lb_target_group_attachment" "tg_attachment_80" {
  target_group_arn = aws_lb_target_group.tg-80.arn
  # attach the ALB to this target group
  target_id        = aws_alb.alb-1.arn
  #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
  port             = 80
  depends_on       = [aws_alb_listener.http-listener]
}

resource "aws_lb_target_group_attachment" "tg_attachment_443" {
  target_group_arn = aws_lb_target_group.tg-443.arn
  target_id        = aws_alb.alb-1.arn
  port             = 443
  depends_on       = [aws_alb_listener.https-listener]
}
