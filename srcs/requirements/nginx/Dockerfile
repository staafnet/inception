FROM debian:bookworm
# Instalacja nginx + openssl + generowanie self-signed certyfikatu SSL
RUN apt-get update && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/CN=rgrochow.42.fr"
# Kopiuje konfigurację nginx (port 443, TLS 1.2/1.3)
COPY conf/nginx.conf /etc/nginx/nginx.conf
# Kopiuje skrypt startowy
COPY tools/nginx-setup.sh /usr/local/bin/
# Nadaje uprawnienia wykonywalne
RUN chmod +x /usr/local/bin/nginx-setup.sh
# Uruchamia skrypt przy starcie kontenera
CMD ["/usr/local/bin/nginx-setup.sh"]
