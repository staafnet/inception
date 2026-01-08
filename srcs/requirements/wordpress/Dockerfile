FROM debian:bookworm
# Instalacja PHP + rozszerzeń + WP-CLI + konfiguracja
RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysql php8.2-cli php8.2-curl \
    php8.2-gd php8.2-mbstring php8.2-xml php8.2-zip \
    mariadb-client wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    mkdir -p /var/www/html /run/php && \
    chown -R www-data:www-data /var/www/html && \
    sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf
# Kopiuje skrypt instalacyjny WordPress
COPY tools/wordpress-setup.sh /usr/local/bin/
# Nadaje uprawnienia wykonywalne
RUN chmod +x /usr/local/bin/wordpress-setup.sh
# Uruchamia skrypt przy starcie kontenera
CMD ["/usr/local/bin/wordpress-setup.sh"]