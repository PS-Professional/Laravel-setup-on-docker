Laravel installer on Docker engine

Developed by PS-Professional

     ____  ____        ____             __               _                   _ 
    |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
    | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
    |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
    |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|

===================================================================================================


What is this project?


This project inclode configurations to setup and run webserver which running Laravel framework. Laravel is a PHP Framework designed for web development. It also uses database applications such as MySQL for better performance.


What will this project do?


This project will make three containers on your Docker host:
     A) A webserver using Nginx image (Nginx:alpine)
     B) A databse using MySQL (mysql:5.7.22)
     C) A container serving PHP tools for serving Laravel (using php:7.2-fpm)

as first step, you need to clone Laravel project form GitHub (git clone https://github.com/laravel/laravel.git). I used the version 6.X for this setup. Then go to the cloned folder. Now we use composer tools to install required tools using its container image (sudo docker run --rm -v $(pwd):/app composer install). Now you just need to install docker-compose and run docker-compose.yml file to start running your webserver (sudo docker-compose up -d).

After sucssesful running of all containers, you need to run some command to finalize your setup. First of all, you need to configure your App container with these commands:

sudo docker-compose exec App php artisan key:generate
sudo docker-compose exec App php artisan config:cache

First command will generate a key and copy it to your .env file, ensuring that your user sessions and encrypted data remain secure and the second command will cache required environment settings ionto a file for more load speed.

After this step, you need to create a DB user for laravel to perform a better security for your database and avoid using root user. To apply this settings to your database, you need to connect to it using sudo docker-compose exec DB bash command to open a shell. After login to container, use mysql -u root -p with the password admin123 to run mysql CLI. Then chech if the laravel database exists using show databases; command. After that, use grant all on laravel.* to 'laraveluser'@'%' identified by 'admin123'; command to create a MySQL user and give required access permisions to laravel database. After this commands, use flush privileges; command to apply all changes. Then exit from MySQL and DB shell using exit command. After applied settings to MySQL, run sudo docker-compose exec App php artisan migrate command to migrate and connet laravel container to MySQL. You can cheack the previous command using sudo docker-compose exec App php artisan tinker command to start a shell and use \DB::table('migrations')->get(); to check if the App container connected to DB container and started using it. after this check, you can exit it using exit() command.

When you done this configurations, you can simply open your web browser and and enter http://your_server_ip:8000 address to see your final result.


Commans in a nutshell:


#Main setup

git clone https://github.com/laravel/laravel.git --branch=6.X

sudo docker run --rm -v $(pwd):/app composer install

sudo docker-compose up -d

#Configuring containers

sudo docker-compose exec App php artisan key:generate

sudo docker-compose exec App php artisan config:cache

sudo docker-compose exec DB bash 

#next commands are in DB prompt

mysql -u root -p (the password is: admin123)

show databases;

grant all on laravel.* to 'laraveluser'@'%' identified by 'admin123';

flush privileges;

exit;

exit

#now you are in your prompt

sudo docker-compose exec App php artisan migrate

#optional for testing the database connetion

docker-compose exec App php artisan tinker

\DB::table('migrations')->get();

exit()


My experience on setup:


As first try, I cloned the last version of Laravel and after running all container, I tried to run commands on App container but I got out-of-date error on PHP version which needed to be >= 7.3. 

After that i tried to use PHP version 7.3 version but on setting up the image, I got errors about ziplib distribution.

At last, I tried Laravel version 6.X and PHP version 7.2 and it finally worked
