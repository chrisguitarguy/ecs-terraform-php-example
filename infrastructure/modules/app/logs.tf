resource "aws_cloudwatch_log_group" "main" {
    name = "${var.app}-${var.env}"
    retention_in_days = 30
}
