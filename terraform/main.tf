provider "aws" {
  region     = "ap-southeast-2"
}

resource "aws_instance" "pcgr" {
  ami           = "ami-ec74648f"
  instance_type = "t2.micro"
  security_groups = ["default"]
  key_name = "mba_wwcrc"
  ebs_block_device {
      device_name = "/dev/xvdf"
      volume_size = "${var.volsize}"
  } 
  provisioner "local-exec" {
    command = "ansible-playbook ../ansible/site.yml -T 60 -e 'ansible_python_interpreter=/usr/bin/python3' -i ${aws_instance.pcgr.public_dns},"
  }
}