# Used for prod build.
FROM php:8.1-fpm as php

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# Install dependencies.
RUN apt-get update && apt-get install -y unzip libpq-dev libcurl4-gnutls-dev nginx libonig-dev

# Install PHP extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath curl opcache mbstring

# Copy composer executable.
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# Copy configuration files.
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Set working directory to /var/www.
WORKDIR /app

# Copy files from current folder to container current folder (set in workdir).
COPY --chown=www-data:www-data . .

# Create laravel caching folders.
RUN mkdir -p /app/storage/framework
RUN mkdir -p /app/storage/framework/cache
RUN mkdir -p /app/storage/framework/testing
RUN mkdir -p /app/storage/framework/sessions
RUN mkdir -p /app/storage/framework/views

# Fix files ownership.
RUN chown -R www-data /app/storage
RUN chown -R www-data /app/storage/framework
RUN chown -R www-data /app/storage/framework/sessions

# Set correct permission.
RUN chmod -R 755 /app/storage
RUN chmod -R 755 /app/storage/logs
RUN chmod -R 755 /app/storage/framework
RUN chmod -R 755 /app/storage/framework/sessions
RUN chmod -R 755 /app/bootstrap

# Adjust user permission & group
RUN usermod --uid 1000 www-data
RUN groupmod --gid 1001 www-data

# Run the entrypoint file.
ENTRYPOINT [ "docker/entrypoint.sh" ]
