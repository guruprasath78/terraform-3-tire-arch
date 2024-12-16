locals {
private_userdata=<<-EOF
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash -x
yum update -y
yum install -y docker
systemctl start docker
usermod -a -G docker ec2-user
docker pull guruteddy/nginx
docker pull guruteddy/rdsaws
docker rm -f $(sudo docker ps -a -q)
docker network create dn
docker run -d --name python_server --network dn -e DB_HOST=${module.rds.endpoint} -e DB_USER=${var.db_username} -e DB_PASSWORD=${var.db_password} -e DB_DATABASE=${var.db_name}  --restart unless-stopped guruteddy/dokpy:latest
docker run -d --name nginx --network dn -p80:80  --restart unless-stopped guruteddy/nginx:latest
--//--
  EOF
}