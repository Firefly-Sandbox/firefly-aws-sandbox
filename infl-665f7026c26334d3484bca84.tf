import {
  to = aws_ebs_volume.vol-0fdb6f22481656163-a5d
  id = "vol-0fdb6f22481656163"
}


import {
  to = aws_instance.test-ec2-w-ebs-1-aa9
  id = "i-00c0ab53a0598979d"
}


resource "aws_ebs_volume" "vol-0fdb6f22481656163-a5d" {
  availability_zone    = "us-east-1c"
  encrypted            = false
  iops                 = 3000
  multi_attach_enabled = false
  size                 = 8
  throughput           = 125
  type                 = "gp3"
}


resource "aws_instance" "test-ec2-w-ebs-1-aa9" {
  ami                         = "ami-00beae93a2d981137"
  associate_public_ip_address = true
  availability_zone           = "us-east-1c"
  cpu_core_count              = 1
  cpu_threads_per_core        = 1
  credit_specification {
    cpu_credits = "standard"
  }
  disable_api_termination = false
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"
    iops                  = 3000
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
  ebs_optimized = false
  enclave_options {
    enabled = false
  }
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "sid-firefly"
  metadata_options {
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }
  monitoring = false
  private_ip = "172.31.83.27"
  root_block_device {
    iops        = 3000
    throughput  = 125
    volume_size = 8
    volume_type = "gp3"
  }
  security_groups = ["default"]
  subnet_id       = "subnet-074045670a9e589ff"
  tags = {
    Name = "test-ec2-w-ebs-1"
  }
  tenancy                = "default"
  vpc_security_group_ids = ["sg-0b2b71e038c748961"]
  # The following attributes have default values introduced when importing the resource into terraform: [timeouts]
  lifecycle {
    ignore_changes = [timeouts]
  }
}

