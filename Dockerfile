FROM php:7.4-fpm

# Copy composer.lock and composer.json
#COPY ./laravel/composer.* /var/www/

# Install composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install dependencies
RUN apt-get update && apt-get upgrade && apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    nginx

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl gd bcmath
#RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
#RUN docker-php-ext-install zip

# Add user for laravel application
#RUN groupadd -g 1000 www-data
#RUN useradd -u 1000 -ms /bin/bash -g www-data www-data

# Clone Laravel application directory contents
RUN rm -rf /var/www/html
RUN git clone https://github.com/laravel/laravel.git /var/www/html
COPY .env /var/www/html
RUN cd /var/www/html
#RUN ls
# Set some permisions
RUN find . -type f -exec chmod 664 {} \;
RUN find . -type d -exec chmod 775 {} \;
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R ug+rwx storage bootstrap/cache

#Nginx configures
RUN touch /var/run/nginx.pid && \
        chown -R www-data:www-data /var/run/nginx.pid && \
        mkdir -p /var/cache/nginx && chown -R www-data:www-data /var/cache/nginx && \
	chown -R www-data:www-data /var/log/nginx && chown -R www-data:www-data /var/lib/nginx
        

# Copy existing application directory permissions
RUN chown -R www-data:www-data /var/www/html

#Composer operations
RUN composer install
RUN composer update

# Change current user to www and set working directory
USER www-data
WORKDIR /var/www/html/

# Expose port 80 and 8080 and start php-fpm and nginx server
EXPOSE 8080
COPY start.sh /entry/start.sh
ENTRYPOINT /entry/start.sh
CMD ["nginx" "-g" "daemon off;"]
