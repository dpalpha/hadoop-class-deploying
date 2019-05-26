#!/usr/bin/env bash



ssh-copy-id localhost


mysql-u root -p$rootpwd

mysql> USE ambaridb;
mysql> CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'ambari_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'localhost';
mysql> CREATE USER 'ambari'@'%' IDENTIFIED BY 'ambari_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'%';
mysql> FLUSH PRIVILEGES;


mysql> USE hivedb;
mysql> CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost';
mysql> CREATE USER 'hive'@'%' IDENTIFIED BY 'hive_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%';
mysql> FLUSH PRIVILEGES;


mysql> USE ooziedb;
mysql> CREATE USER 'oozie'@'localhost' IDENTIFIED BY 'oozie_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'oozie'@'localhost';
mysql> CREATE USER 'oozie'@'%' IDENTIFIED BY 'oozie_password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'oozie'@'%';
mysql> FLUSH PRIVILEGES;



yum install mysql-connector-java*

mysql -u ambari -pambari_password ambaridb <  /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar