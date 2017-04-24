output "task_iam_role" {
    value = "${aws_iam_role.tasks.arn}"
}

output "docker_repo_fpm" {
    value = "${aws_ecr_repository.fpm.repository_url}"
}

output "docker_repo_nginx" {
    value = "${aws_ecr_repository.nginx.repository_url}"
}

output "log_group" {
    value = "${var.app}-${var.env}"
}

output "loadbalancer_dns_name" {
    value = "${aws_alb.main.dns_name}"
}

output "loadbalancer_dns_zone" {
    value = "${aws_alb.main.zone_id}"
}
