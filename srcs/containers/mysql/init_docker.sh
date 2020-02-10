#!/bin/ash
nohup ./init_mysql.sh > /dev/null 2>&1 &
<<<<<<< HEAD

=======
>>>>>>> 168d73d084834cbad9552778711cf57d6d0a0877
sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"
/usr/bin/mysqld_safe --datadir="/var/lib/mysql"

<<<<<<< HEAD
=======
echo UP
>>>>>>> 168d73d084834cbad9552778711cf57d6d0a0877
exit