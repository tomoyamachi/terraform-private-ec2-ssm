output "instance_id_ondemand" {
  value = var.spot_instance ? null : aws_instance.ec2[0].id
}

output "ssh_commands_ondemand" {
  value = var.spot_instance ? null :  "ssh -i <key> <user>@${aws_instance.ec2[0].id}"
}

output "instance_id_spot" {
  value = var.spot_instance ? aws_spot_instance_request.ec2[0].spot_instance_id :null
}

output "ssh_commands_spot" {
  value = var.spot_instance ?  "ssh -i <key> <user>@${aws_spot_instance_request.ec2[0].spot_instance_id}" : null
}
