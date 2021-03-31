Laravel installer on Docker engine

Developed by PS-Professional

     ____  ____        ____             __               _                   _ 
    |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
    | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
    |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
    |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|


## What is this project?

This project inclode configurations to setup and run webserver and host Laravel framework. Laravel is a PHP Framework designed for web development. It also uses database applications such as MySQL for better performance.

## What will this project do?


This project will make three containers on your Docker host:


* A webserver using Apache2 and also Laravel (using php:7.4-apache)

* A databse using MySQL (mysql:5.7.22)


As first step, all you need to do is run the run.sh script to setup files and containers. This script has three functions:
* init 

* start

* setup

* restart

* stop

* update

This script first check your host if Docker exists or not when you use `init` function. If you had installed Docker before, it will ask you for updating system or not and if you didn't installed docker before, it will start installing Docker on yuor host (right now I wrote this script for Debian-based destributions). After that Docker will start getting required files and make them ready for setting containers up. When init function done, you will back to your prompt. Then run the script agian and use `start` function to start containers. When starting done, by using `setup` function you will configure containers but some you need to execute commands yourself (sommands are available in Commands in a nutshell section). When this processes done, you can simply open your web browser and and enter `http://your_server_ip:8080` address to see your final result. If you consider updating php images, you can use the `update` function. If needed, you can restart containers using `restart` function. Finally, to exit from script just use `stop` function.

## Commands in a nutshell:

~~~
#Main setup

./run.sh #init

./run.sh #start

./run.sh #setup

#When you logged into DB container

mysql -u root -p (the password is: admin123)

show databases;

grant all on laravel.* to 'laraveluser'@'%' identified by 'admin123';

flush privileges;

exit;

exit

#When you logged into App container

\DB::table('migrations')->get();

exit()
~~~

## My experience on this project:


As side project of Dockerize Laravel with Nginx web server, I decided to add Apache2 webserver setup to this project. At first, I just tried to do what exactly I did for Nginx and as you guess, it didn't work. My first step of solving this problem was to ignore using `www-data` user and do whatever needed with `root` user. In this step, Apache2 server could start but nothing displayed on port 8080. So i decided to change this port to 80 and everything was OK. Then I realized unlike Nginx, for using onther port on Apache2 server you have to define the port in `/etc/apache2/ports.conf` too. So I created that file and gave it to Apache2 container so it can use port 8080 too.