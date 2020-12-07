FROM nginx

#Update apps
RUN apt update
RUN apt upgrade -y

#Install git and clone files

RUN apt install git -y
RUN git clone https://github.com/laravel/laravel.git /Tmp
RUN cp /Tmp/* /var/www/
RUN rm -rf /Tmp
COPY .env /var/www

# Copy existing application directory permissions
RUN chown -R www:www /var/www

EXPOSE 80
ENTRYPOINT /etc/init.d/nginx start
