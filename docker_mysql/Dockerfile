FROM mysql:8.0.13

COPY mysql_config/devel-db.cnf /etc/mysql/conf.d
COPY mysql_config/create.sql /docker-entrypoint-initdb.d
