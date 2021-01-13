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
  type    = string
  default = "false"
}

variable "localhost"{
  type    = string
  default = "localhost"
}

variable "root_user_password" {
  type    = string
  default = "ChangeMe12345"
}

variable "redmine_user_password" {
  type    = string
  default = "ChangeMe12345"
}
variable "backup_retention_period" {
  type    = number
  default = 30
}
variable "backup_window" {
  type    = string
  default = "00:01-23:30"
}

variable "maintenance_window" {
  type    = string
  default = "Mon:23:31-Tue:00:01"
}
resource "aws_db_instance" "redmine-db" {
  count = var.use_rds == "true" ? 1 : 0
  
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "root"
  password             = var.root_user_password
  parameter_group_name = "default.mysql5.7"
  maintenance_window   = var.maintenance_window
  backup_window        = var.backup_window
  backup_retention_period = var.backup_retention_period
}


resource "aws_instance" "redmine-app" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  security_groups = [ "redmine-sg" ]
  key_name = "conjunto"
  
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./conjunto.pem -i '${aws_instance.redmine-app.public_ip},' ../playbook.yml --extra-vars \"run_mariadb=${var.use_rds != "true"} mariadb_root_password=${var.root_user_password} mariadb_redmine_password=${var.redmine_user_password} mariadb_host=${var.use_rds == "true" ? aws_db_instance.redmine-db[0].address : var.localhost}\" "
    }
    
  provisioner "remote-exec" {
    inline = [
      "mkfs -t ext4 /dev/xvdh",
      "mkdir /backups",
      "mount /dev/xvdh /backups/",
      "echo \"/dev/xvdh /backups ext4 defaults,nofail 0 0\" >> /etc/fstab"
    ]
  
  }
}

resource "aws_ebs_volume" "backup-volume" {
  availability_zone = aws_instance.redmine-app.availability_zone
  size              = 5
}

resource "aws_volume_attachment" "backup-volume-attachment" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.redmine-app.id
  volume_id   = aws_ebs_volume.backup-volume.id
}


output "redmine-ip" {
  value = aws_instance.redmine-app.public_ip
}

output "database-ip" {
  value = aws_db_instance.redmine-db[0].address
}


