#!/bin/bash
#Laravel setup script for Debian-based distributions
#Developed by PS-Professional
#
#
#    ____  ____        ____             __               _                   _
#   |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
#   | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
#   |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
#   |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|
#
#===================================================================================================

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
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
echo Installing done\!
sleep 1
#config files
echo Gitting files from GitHub and running configurations\.\.\.
sleep 1
#git clone git https://github.com/laravel/laravel.git --branch=6.X laravel
sudo docker pull composer
sudo docker run --rm -v $(pwd):/app composer install
sudo docker build -t ps/php php
sudo docker build -t ps/nginx nginx
sudo docker-compose up -d
