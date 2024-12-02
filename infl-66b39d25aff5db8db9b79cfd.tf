import {
  to = module.terraform-aws-ec2-instance.aws_instance.this
  id = "i-0ff8bb1549107f0d9"
}


module "terraform-aws-ec2-instance" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"

  root_block_device = [{
    delete_on_termination = true
    encrypted             = false
    iops                  = "3000"
    kms_key_id            = ""
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"
  }]
  key_name = "sid-firefly"
  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }
  instance_initiated_shutdown_behavior = "stop"
  availability_zone                    = "us-east-1c"
  tags = {
    Name = "test-ec2-w-ebs-2"
  }
  cpu_threads_per_core = 1
  monitoring           = false
  metadata_options = {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
    instance_metadata_tags      = ""
  }
  hibernation = false
  private_ip  = "172.31.85.217"
  ebs_block_device = [{
    delete_on_termination = false
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = "3000"
    kms_key_id            = ""
    snapshot_id           = ""
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"
  }]
  get_password_data           = false
  subnet_id                   = "subnet-074045670a9e589ff"
  vpc_security_group_ids      = ["sg-0b2b71e038c748961"]
  associate_public_ip_address = true
  ebs_optimized               = false
  tenancy                     = "default"
  instance_type               = "t2.micro"
  cpu_core_count              = 1
  source_dest_check           = true
  instance_tags = {
    Name = "test-ec2-w-ebs-2"
  }
  disable_api_termination = false
}

