#!/bin/bash
while ! mariadb -h mariadb -u"$MYSQL_USER" -p"$MYSQL_USER_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 3
done
cd /var/www/html
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_USER_PASSWORD" \
        --dbhost=mariadb \
        --allow-root
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi
exec php-fpm8.2 -F
