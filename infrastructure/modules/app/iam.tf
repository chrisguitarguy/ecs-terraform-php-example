resource "aws_iam_role" "server" {
    name = "server@${var.app}-${var.env}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "Ec2AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "service" {
    name = "ecs@${var.app}-${var.env}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "tasks" {
    name = "tasks@${var.app}-${var.env}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "server_ecs" {
    role = "${aws_iam_role.server.name}"
    # AWS' role for ECS container servers
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "service_ecs" {
    role = "${aws_iam_role.service.name}"
    # AWS' role for ECS service schedule
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_instance_profile" "server" {
    name = "server@${var.app}-${var.env}"
    roles = ["${aws_iam_role.server.id}"]
}
