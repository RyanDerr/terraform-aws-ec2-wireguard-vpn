#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt upgrade -y

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Add user to docker group
sudo usermod -aG docker root

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker
sudo systemctl start docker

# Create directories for Wireguard
mkdir -p ~/wireguard/
mkdir -p ~/wireguard/config/

# Create docker-compose.yml file for Wireguard
cat << EOF > ~/wireguard/docker-compose.yml
version: "2.7"
services:
    wireguard:
        container_name: wireguard
        image: linuxserver/wireguard
        environment:
            - PUID=1000
            - PGID=1000
            - TZ=${TIMEZONE}
            - SERVERURL=${PUBLIC_IP}
            - SERVERPORT=51820
            - PEERS=${DEVICES}
            - PEERDNS=auto
            - INTERNAL_SUBNET=10.0.0.0
        ports:
            - 51820:51820/udp
        volumes:
            - type: bind
              source: ./config/
              target: /config/
            - type: bind
              source: /lib/modules
              target: /lib/modules
        restart: always
        cap_add:
            - NET_ADMIN
            - SYS_MODULE
        sysctls:
            - net.ipv4.conf.all.src_valid_mark=1
EOF

# Start Wireguard container
cd ~/wireguard/
sudo docker-compose up -d