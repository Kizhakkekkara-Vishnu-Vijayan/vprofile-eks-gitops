FROM mysql:8.0

LABEL "Project"="Vprofile"
LABEL "Author"="Vishnu"

ENV MYSQL_DATABASE=accounts
ENV MYSQL_ROOT_HOST="%"

COPY db_backup.sql /docker-entrypoint-initdb.d/01-db_backup.sql

EXPOSE 3306

CMD ["mysqld", \
     "--innodb-buffer-pool-size=64M", \
     "--innodb-log-buffer-size=8M", \
     "--max-connections=50", \
     "--performance-schema=OFF"]
