#!/bin/bash

#Laravel setup script for Debian-based distributions (this will change later!)
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

#Option for later release
#SYS_PKG=`cat /etc/os-release | grep 'ID_LIKE' | cut -f 2 -d '='`

#Functions
function docker_install(){
	#Install docker on your host
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
	sleep 2
	echo Installing done\!
}

function docker_update(){
#Update your system
	echo Updating system\.\.\.
	sleep 1
	sudo apt update && sudo apt upgrade
	sleep 2
	echo Updating Done\!
}

function docker_init(){
	#config files
	echo Gitting files from GitHub and running configurations\.\.\.
	sleep 1
	#git clone git https://github.com/laravel/laravel.git --branch=6.X laravel
	sudo docker pull composer
	sudo docker build -t ps/php:1.0 .
	echo 1.0 > .version
}

function ver_check(){
	if [[ -f .version ]]
	then
		LV=`cat .version`
	else
		echo 1.0 > .version
		LV=`cat .version`
}

function update_image(){
	echo Your last image version is: $LV
	sleep 1
	read -p 'Enter your new version tag: ' New 
	sudo docker build -t ps/php:$New .
	echo $New > .version
	sed 's/'$LV'/'$New'/' docker-compose.yml > tmp && cat tmp > docker-compose.yml && rm tmp
}

#Main funcion
clear
ver_check
echo Hello\! ; sleep 1
echo -e 'What you want me to do?\n1) Setup containers (init)\n2) Start containers (start)\n3) Setup container configurations (setup)\n4) Update image (update)\n5) Restart containers (restart)\n6) Stop containers (stop)\n7) Exit (exit)'
read -p '-> ' func
case $func in
	init )
		if [[ -f /usr/bin/docker ]]
		then
			echo Docker is already exsits in your system
			sleep 1
			State=1
			while [[ $State = 1 ]]
			do
				read -p 'Do you want to check for system updates? ' update
				if [[ $update = 'yes' ]] || [[ $update = 'y' ]]
				then
					docker_update
					State=0
				elif [[ $update = 'no' ]] || [[ $update = 'n' ]]
				then
					echo OK\!
					sleep 1
					State=0
				else
					echo I didn\'t understand\!
					sleep 0.5
					echo Please try again\!
					sleep 0.5
				fi
			done
		else 
			docker_install
		fi
		sleep 1
		docker_init ;;
	start )
		sudo docker-compose up -d && \
		sudo docker-compose exec App /etc/init.d/nginx start ;;
	setup )		
		sudo docker-compose exec App php artisan key:generate && \
		sudo docker-compose exec App php artisan config:cache && \
		echo MySQL\'s Password is \: 'admin123' && \
		sudo docker-compose exec DB bash && \
		sudo docker-compose exec App php artisan migrate
		read -p 'Would you like to test database connection? ' database
		if [[ $database = 'yes' ]] || [[ $database = 'y' ]]
		then
			sudo docker-compose exec --user=root App php artisan tinker
		elif [[ $database = 'no' ]] || [[ $database = 'n' ]]
		then
			echo OK\!
			sleep 1
		else
			echo I didn\'t understand\!
                        sleep 0.5
                        echo Please try again\!
                        sleep 0.5
		fi
		echo Setting up contianers done\!
		sleep 1;;
	update )
		update_image;;
	restart )
		sudo docker-compose down;;
	stop )
		sudo docker-compose down;;
	exit )
		echo Goodbye\!;;
esac
