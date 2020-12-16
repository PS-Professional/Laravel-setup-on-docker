FROM php:7.4-fpm

# Copy composer.lock and composer.json
#COPY ./laravel/composer.* /var/www/

# Install composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
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
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Clone Laravel application directory contents
RUN git clone https://github.com/laravel/laravel.git --branch=6.x /var/www/html
COPY .env /var/www/html
RUN cd /var/www/html
RUN composer install
RUN composer update

# Copy existing application directory permissions
RUN chown -R www:www /var/www/html

# Change current user to www
USER www

# Expose port 80 and start php-fpm and nginx server
EXPOSE 80
COPY start.sh /entry/start.sh
RUN chmod 755 /entry/start.sh
ENTRYPOINT /entry/start.sh
