
locals {
  user_data = <<-EOF
    #!/bin/bash -x
    echo "${tls_private_key.example.private_key_openssh}" > /home/ec2-user/${aws_key_pair.generated_key.key_name}.pem
    EOF
}