terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

variable "use_rds" {
  default = false
}

variable "root_user_password" {
  type    = "string"
  default = "ChangeMe"
}

variable "redmine_user_password" {
  type    = "string"
  default = "ChangeMe"
}

resource "aws_db_instance" "redmine-db" {
  count = "${var.use_rds == true ? 1 : 0}"
  
  allocated_storage    = 2
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "root"
  password             = "${var.root_user_password}"
  parameter_group_name = "default.mysql5.7"
}

resource "aws_instance" "redmine-app" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  security_groups = [ "redmine-sg" ]
  key_name = "conjunto"
  
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./conjunto.pem -i '${aws_instance.redmine-app.public_ip},' ../playbook.yml --extra-vars "run_mariadb=${!use_rds} mariadb_root_password=${var.root_user_password} mariadb_redmine_password=${var.redmine_user_password} mariadb_host=${var.use_rds == true ? ${aws_db_instance.redmine-db.address} : "localhost"}" "
    }
}

output "ip" {
  value = aws_instance.example.public_ip
}

