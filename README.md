Laravel installer on Docker engine

Developed by PS-Professional

     ____  ____        ____             __               _                   _ 
    |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
    | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
    |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
    |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|


## What is this project?

This project inclode configurations to setup and run webserver which running Laravel framework. Laravel is a PHP Framework designed for web development. It also uses database applications such as MySQL for better performance.

## What will this project do?


This project will make three containers on your Docker host:


* A webserver using Nginx image (Nginx:alpine)

* A databse using MySQL (mysql:5.7.22)

* A container serving PHP tools for serving Laravel (using php:7.2-fpm)


As first step, all you need to do is run the run.sh script to setup files and containers. This script has three functions:
* init 

* start

* setup

* stop

This script first check your host if Docker exists or not when you use `init` function. If you had installed Docker before, it will ask you for updating system or not and if you didn't installed docker before, it will start installing Docker on yuor host (right now I wrote this script for Debian-based destributions). After that Docker will start getting required files and make them ready for setting containers up. When init function done, you will back to your prompt. Then run the script agian and use `start` function to start containers. When starting done, by using `setup` function you will configure containers but some you need to execute commands yourself (sommands are available in Commands in a nutshell section). When this processes done, you can simply open your web browser and and enter `http://your_server_ip:8080` address to see your final result. You can sto this cotainers using `stop` function of script.

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

## My experience on setup:


As first try, I cloned the last version of Laravel and after running all container, I tried to run commands on App container but I got out-of-date error on PHP version which needed to be >= 7.3. 

After that i tried to use PHP version 7.3 version but on setting up the image, I got errors about ziplib distribution.

After that, I tried Laravel version 6.X and PHP version 7.2 and it finally worked

At last, tried to use the latest version of PHP and Laravel. What I did for it is cloned Lravel files into php image and after that share that files with Nginx using Volumes. Right now, I combined Nginx and Laravel containers to test if user can update its codes or not.

I checked for Nginx container and I noticed that it start with a non-root user which has no shell (/bin/false) and no home directory is definded for it and permisions of its configuratio files applied for its user. So I decided to use this one for more security and apply it to Laravel files. First thing I done for this purpose is changing ownership of both Laravel and nginx files to `www-data` user and make them available for this user to start this services. After that, I checked out for permisions of Lraravel files. What I did is grant ownership to 'www-data' user to execute Nginx files and run a webserver and also grant required permisions ( 664 for files and 775 for folders) to Laravel files. I had a problem with port forwarding which I forwarded host 8000 port to 80 of 'App' container which made Nginx into bad trouble. I fixed that port and changed 8000 to 8080. 
