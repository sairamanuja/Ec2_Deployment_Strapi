#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

IMAGE="${IMAGE}"

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
systemctl start docker

docker pull ${IMAGE}

mkdir -p /opt/strapi/.tmp
mkdir -p /opt/strapi/public/uploads

docker rm -f strapi-app || true

docker run -d   --name strapi-app   -p 1337:1337   -v /opt/strapi/.tmp:/app/.tmp   -v /opt/strapi/public/uploads:/app/public/uploads   -e NODE_ENV=production   -e HOST=0.0.0.0   -e PORT=1337   -e DATABASE_CLIENT=sqlite   -e DATABASE_FILENAME=.tmp/data.db   -e APP_KEYS="key1,key2,key3,key4"   -e JWT_SECRET="myJwtSecret"   -e ADMIN_JWT_SECRET="myAdminSecret"   -e API_TOKEN_SALT="myApiTokenSalt"   -e TRANSFER_TOKEN_SALT="myTransferTokenSalt"   ${IMAGE}

sleep 5
docker logs strapi-app --tail 200 || true
