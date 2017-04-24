provider "aws" {
    region = "us-east-1"
}

module "app" {
    source = "../modules/app"
    env = "prod"
    app = "ecsterraform"
    key_pair = "websites"
}

resource "aws_route53_record" "app" {
    name = "ecsterraformphp"
    zone_id = "Z3794BPBRJLEA3"
    type = "A"

    alias {
        name = "${module.app.loadbalancer_dns_name}"
        zone_id = "${module.app.loadbalancer_dns_zone}"
        evaluate_target_health = false
    }
}

output "task_role" {
    value = "${module.app.task_iam_role}"
}

output "docker_repo_fpm" {
    value = "${module.app.docker_repo_fpm}"
}

output "docker_repo_nginx" {
    value = "${module.app.docker_repo_nginx}"
}

output "log_group" {
    value = "${module.app.log_group}"
}
