FROM ubuntu:18.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y \
    supervisor \
    nginx \
    php7.2-fpm \
    php7.2-bcmath \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-json \
    php7.2-zip \
    php7.2-mysql \
    php7.2-gd \
    php7.2-curl \
    php7.2-sqlite3 \
    php-redis \
    php-mongodb \
    unzip \
    vim \
    wget \
    git

# install adminer.php
RUN mkdir /usr/share/adminer; \
    wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php; \
    ln -s /usr/share/adminer/latest.php /usr/share/adminer/index.php;

# install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --filename=composer --install-dir=/usr/local/bin/

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/default /etc/nginx/sites-available/default

RUN service nginx restart; \
    service php7.2-fpm start

EXPOSE 80

CMD ["/usr/bin/supervisord"]