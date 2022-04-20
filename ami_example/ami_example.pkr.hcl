packer {
    required_plugins {
        amazon = {
            version = ">= 1.0.9"
            source = "github.com/hashicorp/amazon"
        }
    }
}

############# packer steps #############
# 1. packer init .
# 2. packer validate -var-file="ami_example.pkrvars.hcl" ami_example.pkr.hcl
# 3. packer build -var-file="ami_example.pkrvars.hcl" ami_example.pkr.hcl

## credential and key settings, we can change as vault in the future
variable "aws_access_key" {
    type        = string
    description = "Your aws access key id"
}

variable "aws_secret_key" {
    type        = string
    description = "Setting your subnet id for AMI"
}

variable "ssh_keypair_name" {
    type        = string
    description = "your ssh key pair name"
}

variable "ssh_private_key_file_path" {
    type        = string
    description = "your ssh key pair path"
}

## AWS related settings
variable "aws_region" {
    type        = string
    description = "your aws region"
    default     = "ap-northeast-1"
}

variable "security_group_id"{
    type        = string
    description = "Setting your Security Group id for AMI"
}

variable "subnet_id"{
    type        = string
    description = "Setting your Subnet id for AMI"
}

variable "vpc_id"{
    type        = string
    description = "Setting your VPC id for AMI"
}

variable "based_ami_id"{
    type        = string
    description = "Your based AMI ID"
    default     = "ami-088da9557aae42f39"
}

variable "instance_type"{
    type        = string
    description = "Your based AMI ID"
    default     = "t3.small"
}

variable "test_var"{
    type        = string
    description = "test variable"
    default     = "just test"
}

source "amazon-ebs" "ami-example" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
    
    source_ami = var.based_ami_id
    ami_name = "packer-ami-exampl-${var.env}"
    ami_description = "The AMI for example with packer"
    instance_type = var.instance_type
    
    ssh_keypair_name = var.ssh_keypair_name
    ssh_private_key_file = var.ssh_private_key_file_path
    ssh_username = "ubuntu"
    security_group_id = var.security_group_id
    subnet_id = var.subnet_id
    vpc_id = var.vpc_id

    ## additional volume
    launch_block_device_mappings {
        device_name = "/dev/sda1"
        volume_size = 12
        volume_type = "gp2"
        delete_on_termination = true
    }

    tags = {
        Name = "packer-ami-example-${var.env}"
        Cost = "infra"
        Environment = "${var.env}"
    }

}
# amazon-ebs
build {
    sources = [
        "source.amazon-ebs.ami-example"
    ]

    provisioner "file" {
        source = "./ami-example.service"
        destination = "/tmp/ami-example.service"
    }

    provisioner "shell" {
        script = "./init.sh"
        environment_vars = [
            "EXTERNAL_VARS=${var.test_var}",
        ]
    }
}
