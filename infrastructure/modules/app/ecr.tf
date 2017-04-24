resource "aws_ecr_repository" "fpm" {
    name = "${lower(var.app)}-${var.env}-fpm"
}

resource "aws_ecr_repository" "nginx" {
    name = "${lower(var.app)}-${var.env}-nginx"
}
