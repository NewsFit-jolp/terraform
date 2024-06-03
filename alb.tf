resource "aws_lb" "newsfit_lb" {
  name               = "newsfit-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.newsfit_sg.id]
  subnets            = [aws_subnet.newsfit_vpc_public_subnet_1.id, aws_subnet.newsfit_vpc_public_subnet_2.id]

  tags = {
    Name = "newsfit_alb"
  }
}

resource "aws_lb_target_group" "newsfit_tg" {
  name     = "newsfit-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.newsfit_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = var.aws_lb_target_group_health_check_path
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "newsfit_tg"
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.newsfit_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.newsfit_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.newsfit_certificate_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.newsfit_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "newsfit_tg_attachment" {
  target_group_arn = aws_lb_target_group.newsfit_tg.arn
  target_id        = aws_instance.newsfit_webserver.id
  port             = var.aws_lb_target_group_attachment_port
}
