resource "aws_ecs_cluster" "main" {
    name = "${lower(var.app)}-${var.env}"
}

resource "aws_launch_configuration" "main" {
    name_prefix = "${lower(var.app)}-${var.env}"
    image_id = "${var.container_ami}"
    instance_type = "t2.nano"
    key_name = "${var.key_pair}"
    security_groups = [
        "${aws_security_group.outbound.id}",
        "${aws_security_group.server.id}"
    ]
    iam_instance_profile = "${aws_iam_instance_profile.server.id}"
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "main" {
    name = "${lower(var.app)}-${var.env}"
    launch_configuration = "${aws_launch_configuration.main.name}"
    max_size = "${2 * length(aws_subnet.private.*.id)}"
    min_size = 1
    desired_capacity = "${length(aws_subnet.private.*.id)}"
    vpc_zone_identifier = ["${aws_subnet.private.*.id}"]

    tag {
        key = "Name"
        value = "${var.app} ECS"
        propagate_at_launch = true
    }

    tag {
        key = "Application"
        value = "${var.app}"
        propagate_at_launch = true
    }

    tag {
        key = "Environment"
        value = "${var.env}"
        propagate_at_launch = true
    }
}
