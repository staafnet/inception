FROM debian:bookworm
# Instalacja MariaDB + czyszczenie cache + setup katalogu socket
RUN apt-get update && apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld
# Kopiuje konfigurację (bind-address 0.0.0.0)
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# Kopiuje skrypt startowy
COPY tools/mariadb-setup.sh /usr/local/bin/
# Nadaje uprawnienia wykonywalne
RUN chmod +x /usr/local/bin/mariadb-setup.sh
# Uruchamia skrypt przy starcie kontenera
CMD ["/usr/local/bin/mariadb-setup.sh"]
