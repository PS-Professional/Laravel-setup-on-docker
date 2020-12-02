#!/bin/bash
#Install Docker
echo installing Docker\.\.\.
sleep 1
sudo apt update
sudo apt install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
echo Installing done\!
sleep 1
#config files
echo Gitting files from GitHub and running configurations\.\.\.
sleep 1
git clone git https://github.com/laravel/laravel.git --branch=6.X laravel
sudo docker-compose up -d
