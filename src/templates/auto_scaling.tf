resource "aws_launch_configuration" "web_server" {
  image_id        = "${var.amis["web_server"]}"
  instance_type   = "${var.instance_types["web_server"]}"
  security_groups = ["${aws_security_group.web_server.id}"]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_server" {
  vpc_id      = "${aws_vpc.main.id}"
  tags        = "${var.tags}"

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.load_balancer.id}"]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }

  egress {
    description = "TCP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      "${var.private_subnet1_cidr_block}",
      "${var.private_subnet2_cidr_block}"
    ]
  }
}

resource "aws_autoscaling_group" "web_server" {
  launch_configuration = "${aws_launch_configuration.web_server.name}"
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  vpc_zone_identifier  = [
    "${var.private_subnet1_cidr_block}",
    "${var.private_subnet2_cidr_block}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.web_server.id}"
  alb_target_group_arn   = "${aws_lb_target_group.http.arn}"
}
