#!/bin/bash

exec > /var/log/bootstrap.log 2>&1

# UPDATE
apt-get update -y

# INSTALL BASE PACKAGES
apt-get install -y nginx git curl software-properties-common

# INSTALL NODEJS 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt-get install -y nodejs

# VERIFY NODE + NPM
node -v
npm -v

# INSTALL PM2
npm install -g pm2

# VERIFY PM2
pm2 -v

# MOVE HOME
cd /home/aswin1015

# REMOVE OLD REPO IF EXISTS
rm -rf organic-ghee

# CLONE REPO
git clone https://github.com/Msocial123/organic-ghee.git

cd organic-ghee

# INSTALL DEPENDENCIES
npm install

# START APP
pm2 start src/app.js --name organic-ghee

# SAVE PM2
pm2 save

# ENABLE PM2 ON BOOT
pm2 startup systemd -u aswin1015 --hp /home/aswin1015

# NGINX CONFIG
cat <<EOF > /etc/nginx/sites-available/custom
server {

    listen 80;

    server_name _;

    location / {

        proxy_pass http://localhost:5656;

        proxy_http_version 1.1;

        proxy_set_header Upgrade \$http_upgrade;

        proxy_set_header Connection 'upgrade';

        proxy_set_header Host \$host;

        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

ln -sf /etc/nginx/sites-available/custom /etc/nginx/sites-enabled/custom

rm -f /etc/nginx/sites-enabled/default

systemctl restart nginx

systemctl enable nginx