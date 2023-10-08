#!/bin/sh

set -e

# Change permissions
chmod 644 /etc/my.cnf /etc/my.cnf.d/mariadb-server.cnf

mariadbd --user=mysql --datadir=/var/lib/mysql --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS root@localhost IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
SET PASSWORD FOR root@localhost = PASSWORD('$MYSQL_ROOT_PASSWORD');
GRANT ALL ON *.* TO root@localhost WITH GRANT OPTION;
CREATE USER IF NOT EXISTS root@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
SET PASSWORD FOR root@'%' = PASSWORD('$MYSQL_ROOT_PASSWORD');
GRANT ALL ON *.* TO root@'%' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
SET PASSWORD FOR $MYSQL_USER@'%' = PASSWORD('$MYSQL_PASSWORD');
EOF

# Execute
exec $@
