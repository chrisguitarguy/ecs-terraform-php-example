resource "aws_alb" "main" {
    name = "${lower(var.app)}-${lower(var.env)}-lb"
    security_groups = [
        "${aws_security_group.outbound.id}",
        "${aws_security_group.loadbalancer.id}",
    ]
    subnets = ["${aws_subnet.public.*.id}"]
    internal = false

    tags {
        Application = "${var.app}"
        Environment = "${var.env}"
        Name = "${var.app} Load Balancer"
    }
}

resource "aws_alb_target_group" "main_containers" {
    name = "${var.app}-${var.env}-http"
    port = 8080
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
    health_check {
        path = "/health"
        healthy_threshold = 2
    }
}

resource "aws_alb_listener" "main_http" {
    load_balancer_arn = "${aws_alb.main.arn}"
    port = 80
    protocol = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.main_containers.arn}"
        type = "forward"
    }
}
