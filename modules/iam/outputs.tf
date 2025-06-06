output "instance_profile_name" {
  value = aws_iam_instance_profile.gergo_runner_profile.name
}

output "security_group_id" {
  value = aws_security_group.gergo_runner_sg.id
}