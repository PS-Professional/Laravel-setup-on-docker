<h1 align="center"><b>Laravel-Docker</b></h1>

### What is this project?

This project inclode configurations to setup and run webserver and host Laravel framework. Laravel is a PHP Framework designed for web development. It also uses database applications such as MySQL for better performance.

### What will this project do?


This project will make two containers on your Docker host:

* A databse using MySQL (mysql:5.7.22)

* A container with Laravel also Nginx webserver installed (using php:7.4-fpm)


As first step, all you need to do is run the run.sh script to setup files and containers. This script has seven functions:
* init 

* start

* setup

* update

* restart

* stop

* exit

This script first check your host if Docker exists or not when you use `init` function. If you had installed Docker before, it will ask you for updating system or not and if you didn't installed docker before, it will start installing Docker on yuor host (right now I wrote this script for Debian-based destributions). After that Docker will start getting required files and make them ready for setting containers up. When init function done, you will back to your prompt. Then run the script agian and use `start` function to start containers. When starting done, by using `setup` function you will configure containers but some you need to execute commands yourself (sommands are available in Commands in a nutshell section). When this processes done, you can simply open your web browser and and enter `http://your_server_ip:8080` address to see your final result. If you consider updating php images, you can use the `update` function. If needed, you can restart containers using `restart` function and to shut it down, just use `stop` function. Finally, to exit from script just use `exit` function.

### Commands in a nutshell:

```bash
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

#Optional
#When you logged into App container

\DB::table('migrations')->get();

exit()
```

### My experience on this project:


As first try, I cloned the last version of Laravel and after setup all container, I tried to run commands on App container but I got out-of-date error on PHP version which needed to be >= 7.3. 

After that i tried to use PHP version 7.3 version but when I was building custom image, I got errors about ziplib package.

After that, I tried Laravel version 6.X and PHP version 7.2 and it finally worked.

Then I decided to use the latest version of both PHP and Laravel. To do this, I cloned Lravel files into php image and after that share that files with Nginx using Volumes.

I checked for Nginx official Docker Hub image and I noticed that it starts with a non-root user which has no shell (/usr/bin/false) and no home directory is definded for the user and ownership of its configuratio files was its user. So I decided to use this one for more security and applied it to Laravel files. First thing I done for this purpose is changing ownership of both Laravel and Nginx files to `www-data` user and make them available for this user to start this services. After that, I checked out for permisions of Lraravel files. What I did is grant ownership to `www-data` user to execute Nginx files and run a webserver and also grant required permisions ( 664 for files and 775 for folders) to Laravel files. I had a problem with port forwarding which I forwarded host 8000 port to 80 of `App` container which made Nginx into bad trouble. I fixed that port and changed wrong 80 to 8080. 

My new feature for this scrpit is update images, which you had to do manually. Right now, this function will ask you for your newer tag and build the newer image for you and also gives the latest version tag to it.
