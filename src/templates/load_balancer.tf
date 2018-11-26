resource "aws_lb" "main" {
  security_groups = ["${aws_security_group.load_balancer.id}"]
  tags            = "${var.tags}"
  subnets         = [
    "${aws_subnet.public_subnet1.id}",
    "${aws_subnet.public_subnet2.id}"
  ]
}

resource "aws_security_group" "load_balancer" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "${var.private_subnet1_cidr_block}",
      "${var.private_subnet2_cidr_block}"
    ]
  }
}

resource "aws_lb_target_group" "http" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  tags     = "${var.tags}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.http.arn}"
  }
}
