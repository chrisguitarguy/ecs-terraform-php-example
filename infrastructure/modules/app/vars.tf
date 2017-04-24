variable "app" {
    type = "string"
    description = "An application name (used in tags and such)"
}

variable "env" {
    type = "string"
    description = "The application environment (prod, stage, etc)"
}

variable "key_pair" {
    type = "string"
    description = "The key pair name to use creating the servers"
}


variable "container_ami" {
    type = "string"
    description = "The container service servers will use. Defaults to the latest ECS optimized AMI."
    default = "ami-40286957"
}
