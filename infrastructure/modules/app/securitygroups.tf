resource "aws_security_group" "outbound" {
    name = "outbound@${lower(var.app)}-${var.env}"
    description = "Allow output connections to everywhere."
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

# allow output access to everywhere from the bastion server
resource "aws_security_group_rule" "outbound" {
    type = "egress"
    security_group_id = "${aws_security_group.outbound.id}"
    from_port = -1
    to_port = -1
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "loadbalancer" {
    name = "loadbalancer@${lower(var.app)}-${var.env}"
    description = "${var.app} security for the main load balancer"
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_security_group_rule" "lb_http" {
    type = "ingress"
    security_group_id = "${aws_security_group.loadbalancer.id}"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "server" {
    name = "server@${lower(var.app)}-${var.env}"
    description = "${var.app} security group for ECS servers"
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_security_group_rule" "loadbalancer_server" {
    type = "ingress"
    security_group_id = "${aws_security_group.server.id}"
    source_security_group_id = "${aws_security_group.loadbalancer.id}"
    protocol = "tcp"
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#ContainerDefinition-portMappings-hostPort
    from_port = 32768
    to_port = 65535
}
