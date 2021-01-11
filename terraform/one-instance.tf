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

variable "use_rds_database" {
  default = "false"
}


resource "aws_instance" "example" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  security_groups = [ "launch-wizard-4" ]
  key_name = "mchichi"
  
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./mchichi.pem -i '${aws_instance.example.public_ip},' playbook.yml"
    }
}

output "ip" {
  value = aws_instance.example.public_ip
}

