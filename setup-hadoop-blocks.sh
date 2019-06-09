#!/usr/bin/env bash

cat << "EOF"
HADOOOP 2W TEZ
......... ....... ............ ........... ..........
. Script. . Sql . . Java     . . Engines . . Othres .
......... ....... ............ ........... ..........
. Pig   . .Hive . . cascaing . .Hbase    . . Engines.
......... ....... ............ .Kafka    . ..........
. TEZ   . . TEZ . . TEZ      . .Spark    . . TEZ    .
......... ....... ............ ........... ..........
===={}======={}========{}==========={}========={}====
|||||||||||||YARN: Data Operating System ||||||||||||
|||||||||| ( Cluseter Resource Management) ||||||||||
-----------------------------------------------------
|\\\\\\\\\\ HDFS HADOOP DISTIBUTED FILE SYSTEM///////|
=====================================================
EOF


# preparing user hadoop groups

sudo userdel -r hduser
sudo groupdel hadoop

sudo groupadd hadoop
sudo useradd --ingroup hadoop hduser

su - hduser

ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys 

sudo chown -R hduser:hadoop /opt/hadoop
sudo chmod -R 777 /opt/hadoop



# provide privileges hduser as root user
sudo echo "hduser ALL=(ALL:ALL) ALL" >> ~/visudo

cat << "EOF"
--------------------------------------------
preparation part tools
--------------------------------------------
--------------------------------------------
EOF

yum -y install wget gcc gcc-c++ autoconf automake libtool zlib-devel cmake openssl openssl-devel snappy snappy-devel bzip2 bzip2-devel protobuf protobuf-devel
# apt-get install libcppunit-dev
# sudo apt install protobuf-compiler

cd /usr/local/src/
wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
tar xvf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
./autogen.sh
./configure --prefix=/usr
make
make install
protoc --version



# sudo yum remove cmake -y
cd /home
wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz
tar -zxvf cmake-3.6.2.tar.gz
mv /home/cmake-3.6.2 /opt/cmake-3.6.2
cd /opt/cmake-3.6.2
sudo ./bootstrap --prefix=/opt
sudo make
sudo make install

echo "# set cmake-3.6.2 env " >> ~/.bashrc
echo "export PATH=/opt/cmake-3.6.2/bin:\$PATH:\$HOME/bin" >> ~/.bashrc
source ~/.bashrc


# export M2_HOME=/opt/maven
# export PATH=$M2_HOME/bin:$PATH

cat << "EOF"
--------------------------------------------
preparation java jdk env
--------------------------------------------
EOF

cd /home
#wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.tar.gz
#tar xvf ~/jdk-8u171-linux-x64.tar.gz
#mv ~/jdk1.8.0_171 /opt/java
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk" >> ~/.bashrc
echo "export PATH=/usr/lib/jvm/java-1.8.0-openjdk/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

cat << "EOF"
--------------------------------------------
preparation maven env
--------------------------------------------
EOF


cd home
wget http://apache.rediris.es/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
tar xvf /home/apache-maven-3.6.1-bin.tar.gz
mv /home/apache-maven-3.6.1 /opt/maven
echo "#set env MAVEN" >> ~/.bashrc
echo "PATH=/opt/maven/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc



cat << "EOF"
--------------------------------------------
preparation maven env
--------------------------------------------
EOF

cd /home
wget http://apache.rediris.es/ant/binaries/apache-ant-1.10.5-bin.tar.gz
tar -xvf /home/apache-ant-1.10.5-bin.tar.gz
mv /home/apache-ant-1.10.5 /opt/ant
echo "#set env ANT" >> ~/.bashrc
echo "PATH=/opt/ant/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc



cat << "EOF"
--------------------------------------------
preparation zookeeper env
--------------------------------------------
--------------------------------------------

EOF
sudo apt-get install build-essential libboost-all-dev cmake flex
cd /home
wget http://apache.rediris.es/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz
tar -xvf apache-zookeeper-3.5.5.tar.gz
cd apache-zookeeper-3.5.5
ant clean tar
tar -C/opt -xvf build/zookeeper-3.5.5-SNAPSHOT.tar.gz
mv /opt/zookeeper-3.5.5-SNAPSHOT /opt/zookeeper
mkdir /opt/zookeeper/data
echo 1 > /opt/zookeeper/data/myid

cat << EOF > /opt/zookeeper/conf/zoo.cfg
clientPort=2181
dataDir=/opt/zookeeper/data
server.1=localhost:2888:3888
EOF

cat << EOF > /opt/zookeeper/conf/zookeeper-env.sh
ZOO_LOG_DIR=/opt/zookeeper/logs
EOF
echo "PATH=/opt/zookeeper/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc
zkServer.sh start
# ps aux|grep zookeeper

cat << "EOF"
--------------------------------------------
preparation hadoop native version env
--------------------------------------------
--------------------------------------------
EOF



# Disable SELinux (this is known to cause issues with Hadoop):
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo sed -i "\$anet.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf
sudo sed -i "\$anet.ipv6.conf.default.disable_ipv6 = 1" /etc/sysctl.conf
sudo sysctl -p


sudo groupadd hadoop
sudo useradd -g hadoop hduser
su - hduser


ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# downloading hadoop


cd /home
wget http://apache.rediris.es/hadoop/common/hadoop-3.1.1/hadoop-3.1.1-src.tar.gz
tar -xvf /home/hadoop-3.1.1-src.tar.gz
mv /home/hadoop-3.1.1-src /home/hadoop-src
cd /home/hadoop-src
mvn package -Pdist,native -DskipTests -Dtar -Dzookeeper.version=3.5.5
tar -C/opt -xvf /home/hadoop-src/hadoop-dist/target/hadoop-3.1.1.tar.gz
mv /opt/hadoop-* /opt/hadoop
mv /opt/hadoop /opt/hadoop_native
mv /opt/hadoop_native/hadoop /opt/hadoop
mv /opt/hadoop/hadoop-3.1.1 /home/hadoop
mv /home/hadoop /opt/hadoop
echo "PATH=\"/opt/hadoop/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc


sudo chown -R hduser:hadoop /opt/hadoop
sudo chmod -R 777 /opt/hadoop

sudo chgrp -R hadoop /opt/hadoop
sudo chmod -R 777 /opt/hadoop


echo "#set hadooop path env" >> ~/.bashrc
echo "export HADOOP_HOME=/opt/hadoop" >> ~/.bashrc
echo "export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=/opt/hadoop" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=/opt/hadoop" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=/opt/hadoop" >> ~/.bashrc
echo "export YARN_HOME=/opt/hadoop" >> ~/.bashrc
echo "export PATH=\$PATH:/opt/hadoop/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/opt/hadoop/sbin" >> ~/.bashrc

echo "#set super su to hadoop" >> ~/.bashrc
echo "export HDFS_NAMENODE_USER='root'" >> ~/.bashrc
echo "export HDFS_DATANODE_USER='root'" >> ~/.bashrc
echo "export HDFS_SECONDARYNAMENODE_USER='root'" >> ~/.bashrc
echo "export YARN_RESOURCEMANAGER_USER='root'" >> ~/.bashrc
echo "export YARN_NODEMANAGER_USER='root'" >> ~/.bashrc

echo "#HADOOP NATIVE PATH:" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export HADOOP_OPTS='-Djava.library.path=\$HADOOP_HOME/lib'" >> ~/.bashrc
source ~/.bashrc


echo "export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true" >> /opt/hadoop/etc/hadoop/hadoop-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk" >> /opt/hadoop/etc/hadoop/hadoop-env.sh
echo "export HADOOP_HOME_WARN_SUPPRESS='TRUE'" >> /opt/hadoop/etc/hadoop/hadoop-env.sh
echo "export HADOOP_ROOT_LOGGER='WARN,DRFA'" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

source /opt/hadoop/etc/hadoop/hadoop-env.sh


cat << EOF > /opt/hadoop/etc/hadoop/yarn-site.xml
<configuration>
  <property><name>yarn.resourcemanager.hostname</name><value>localhost</value></property>

  <property><name>yarn.scheduler.minimum-allocation-mb</name><value>1024</value></property>
  <property><name>yarn.scheduler.increment-allocation-mb</name><value>1024</value></property>
  <property><name>yarn.scheduler.maximum-allocation-mb</name><value>1024</value></property>
  <property><name>yarn.scheduler.minimum-allocation-vcores</name><value>1</value></property>
  <property><name>yarn.scheduler.increment-allocation-vcores</name><value>1</value></property>
  <property><name>yarn.scheduler.maximum-allocation-vcores</name><value>1</value></property>

  <property><name>yarn.nodemanager.resource.memory-mb</name><value>4096</value></property>
  <property><name>yarn.nodemanager.resource.cpu-vcores</name><value>4</value></property>

  <property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>
  <property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property>

  <property><name>yarn.log-aggregation-enable</name><value>true</value></property>
  <property><name>yarn.nodemanager.local-dirs</name><value>/data/yarn/local</value></property>
  <property><name>yarn.nodemanager.log-dirs</name><value>/data/yarn/log</value></property>
  <property><name>yarn.nodemanager.vmem-check-enabled</name><value>false</value></property>
</configuration>
EOF


cat << EOF > /opt/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
<property><name>dfs.replication</name><value>1</value></property>
<property><name>dfs.namenode.name.dir</name><value>file:/opt/hadoop/yarn_data/hdfs/namenode</value></property>
<property><name>dfs.datanode.data.dir</name><value>file:/opt/hadoop/yarn_data/hdfs/datanode</value></property>
<property><name>dfs.namenode.checkpoint.dir</name><value>file:/opt/hadoop/yarn_data/hdfs/namenode_second</value></property>
</configuration>
EOF


cat << EOF > /opt/hadoop/etc/hadoop/core-site.xml
<configuration>
<property><name>hadoop.tmp.dir</name><value>/app/hadoop/tmp</value></property>
<property><name>fs.default.name</name><value>hdfs://localhost:9000</value></property>
</configuration>
EOF


cat << EOF > /opt/hadoop/etc/hadoop/mapred-site.xml
<configuration>
  <property><name>mapred.framework.name</name><value>yarn</value></property>

  <property><name>mapreduce.job.reduce.slowstart.completedmaps</name><value>0.8</value></property>
  <property><name>yarn.app.mapreduce.am.resource.cpu-vcores</name><value>1</value></property>
  <property><name>yarn.app.mapreduce.am.resource.mb</name><value>1024</value></property>
  <property><name>yarn.app.mapreduce.am.command-opts</name><value>-Djava.net.preferIPv4Stack=true -Xmx768m</value></property>
  <property><name>mapreduce.map.cpu.vcores</name><value>1</value></property>
  <property><name>mapreduce.map.memory.mb</name><value>1024</value></property>
  <property><name>mapreduce.map.java.opts</name><value>-Djava.net.preferIPv4Stack=true -Xmx768m</value></property>
  <property><name>mapreduce.reduce.cpu.vcores</name><value>1</value></property>
  <property><name>mapreduce.reduce.memory.mb</name><value>1024</value></property>
  <property><name>mapreduce.reduce.java.opts</name><value>-Djava.net.preferIPv4Stack=true -Xmx768m</value></property>
  
  <property><name>mapreduce.jobhistory.address</name><value>localhost:10020</value></property>
  <property><name>mapreduce.jobhistory.webapp.address</name><value>localhost:19888</value></property>

</configuration>
EOF


sudo mkdir -p /app/hadoop/tmp
sudo chown -R hduser:hadoop /app/hadoop/tmp
sudo chmod -R 777 /app/hadoop/tmp

sudo mkdir -p /opt/hadoop/yarn_data/hdfs/namenode
sudo mkdir -p /opt/hadoop/yarn_data/hdfs/datanode
sudo mkdir -p /opt/hadoop/yarn_data/hdfs/namenode_second

sudo chmod -R 777 /opt/hadoop/yarn_data/hdfs/namenode
sudo chmod -R 777 /opt/hadoop/yarn_data/hdfs/datanode
sudo chmod -R 777 /opt/hadoop/yarn_data/hdfs/namenode_second

sudo chown -R hduser:hadoop /opt/hadoop/yarn_data/hdfs/namenode
sudo chown -R hduser:hadoop /opt/hadoop/yarn_data/hdfs/datanode
sudo chown -R hduser:hadoop /opt/hadoop/yarn_data/hdfs/namenode_second

chmod u+rwx,g-rwx,o+rx-w /opt/hadoop/yarn_data/hdfs/namenode
chmod u+rwx,g-rwx,o+rx-w /opt/hadoop/yarn_data/hdfs/namenode_second

hadoop namenode -format

start-dfs.sh
start-yarn.sh


hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar pi 16 1000
yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar pi 3 100000


hdfs dfs -mkdir input
hdfs dfs -put /opt/hadoop/LICENSE.txt input

hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar grep input output 'dfs[a-z.]+'^C


hdfs dfs -mkdir -p /hduser
hdfs dfs -chown hduser:hduser /hduser
hdfs dfs -mkdir /tmp
hdfs dfs -chmod 1777 /tmp



hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
mr-jobhistory-daemon.sh start historyserver


# sudo firefox http://localhost:8088/
# sudo firefox http://localhost:9870/



# SPARK-2.4.3
cat << "EOF"
--------------------------------------------
preparation spark src env
--------------------------------------------
EOF

cd /home
wget http://apache.rediris.es/spark/spark-2.4.3/spark-2.4.3.tgz
tar -xvf spark-2.4.3.tgz
cd /home/spark-2.4.3
dev/make-distribution.sh --name custom-spark --tgz "-Pyarn,hadoop" -Dhadoop -DskipTests
tar -C/opt -xvf spark-2.4.3-bin-custom-spark.tgz
cd /opt
mv spark-* spark
echo "PATH=\"/opt/spark/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc

cd /opt/spark/conf

cat << EOF > spark-env.sh
HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
#export SPARK_DIST_CLASSPATH=$(hadoop classpath)
EOF

cat << EOF > spark-defaults.conf
spark.driver.memory              512m
spark.executor.memory            512m
EOF


# HBASE-2.1.4
cat << "EOF"
--------------------------------------------
preparation hbase src env
--------------------------------------------
EOF


cd /home
wget http://apache.rediris.es/hbase/2.1.4/hbase-2.1.4-src.tar.gz
tar -xvf hbase-2.1.4-src.tar.gz
cd hbase-2.1.4
mvn clean package assembly:single -DskipTests -Dhadoop.version=3.1.1 -Dzookeeper
tar -C/opt -xvf hbase-assembly/target/hbase-2.1.4-bin.tar.gz
mv /opt/hbase-* /opt/hbase
echo "PATH=/opt/hbase/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

cat << EOF > /opt/hbase/conf/hbase-site.xml
<configuration>
<property><name>hbase.cluster.distributed</name><value>true</value></property>
<property><name>hbase.rootdir</name><value>hdfs://localhost:8020/hbase</value></property>
<property><name>hbase.zookeeper.quorum</name><value>localhost</value></property>
</configuration>
EOF

hbase-daemon.sh start master
hbase-daemon.sh start thrift
hbase-daemon.sh start regionserver


# HIVE-3.1.1
cat << "EOF"
--------------------------------------------
preparation hive src env
--------------------------------------------
EOF


cd /home
wget http://apache.rediris.es/hive/hive-3.1.1/apache-hive-3.1.1-src.tar.gz
tar -xvf apache-hive-3.1.1-src.tar.gz
cd apache-hive-3.1.1-src
sed -i '/<dependencies>/a <dependency><groupId>junit</groupId><artifactId>junit</artifactId><scope>test</scope></dependency>' shims/common/pom.xml
mvn clean package -Dhadoop.version=3.1.1 -DskipTests -Pdist
tar -C/opt -xvf ./packaging/target/apache-hive-3.1.1-bin.tar.gz
mv /opt/apache-hive-* /opt/hive
echo "PATH=\"/opt/hive/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc


cat << "EOF"
--------------------------------------------
preparation mariadb src env
--------------------------------------------
EOF

cd /home
yum -y install mariadb-server mariadb
systemctl restart mariadb
systemctl enable mariadb
cat << EOF | mysql
delete from mysql.user WHERE User='';
create database hive;
grant all privileges on hive.* to 'hive'@'%' identified by 'hive';
grant all privileges on hive.* to 'hive'@'localhost' identified by 'hive';
flush privileges;
EOF
wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.16.tar.gz
tar -xvf mysql-connector-java-8.0.16.tar.gz
cp mysql-connector-java-8.0.16/mysql-connector-java-8.0.16.jar /opt/hive/lib/

cd /opt/hive
cat << EOF > /opt/hive/conf/hive-site.xml
<configuration>
  <property><name>javax.jdo.option.ConnectionURL</name><value>jdbc:mysql://localhost/hive?createDatabaseIfNotExist=true</value></property>
  <property><name>javax.jdo.option.ConnectionDriverName</name><value>com.mysql.jdbc.Driver</value></property>
  <property><name>javax.jdo.option.ConnectionUserName</name><value>hive</value></property>
  <property><name>javax.jdo.option.ConnectionPassword</name><value>hive</value></property>
  <property><name>hive.server2.enable.doAs</name><value>true</value></property>
</configuration>
EOF
schematool -dbType mysql -initSchema
hive --service metastore --hiveconf hive.log.dir=/opt/hive/logs --hiveconf hive.log.file=metastore.log >/dev/null 2>&1 &
hive --service hiveserver2 --hiveconf hive.log.dir=/opt/hive/logs --hiveconf hive.log.file=hs2.log >/dev/null 2>&1 &


# PIG 0.17
cat << "EOF"
--------------------------------------------
preparation pig src env
--------------------------------------------
EOF

<!--
#cd /home
#wget http://apache.rediris.es/pig/pig-0.16.0/pig-0.16.0-src.tar.gz
#tar -xvf pig-0.17.0-src.tar.gz.1
#cd pig-0.17.0-src
#sed -i '/<\/dependencies>/i \
#    <dependency org="org.apache.hadoop" name="hadoop-hdfs-client" rev="${hadoop-hdfs.version}" conf="hadoop3->master"><artifact name="hadoop-hdfs-client" ext="jar" /></dependency>' ivy.xml
#sed -i 's/target name="package" depends="jar, docs/target name="package" depends="jar/g' build.xml
#ant -Dhadoop -Dzookeeper.version=3.5.5 -Dhadoop-common.version=3.1.1 -Dhadoop-hdfs.version=3.1.1 -Dhadoop-mapreduce.version=3.1.1 tar
#tar -C/opt -xvf /root/pig-0.17.0-src/build/pig-0.17.0-SNAPSHOT.tar.gz
#mv /opt/pig-* /opt/pig
#echo "PATH=\"/opt/pig/bin:\$PATH\"" >> ~/.bashrc
#source ~/.bashrc

cd /home;
urlpig=http://ftp.man.poznan.pl/apache/pig/pig-0.17.0/pig-0.17.0-src.tar.gz
wget $urlpig
tar xvzf /home/pig-0.17.0.tar.gz;
mv pig-0.17.0 /opt/pig
rm xvzf /home/pig-0.17.0.tar.gz

echo "export PATH=/opt/pig/bin:\$PATH" >> ~/.bashrc
echo "export PIG_HOME=/opt/pig/" >> ~/.bashrc
echo "export PIG_CLASSPATH=/opt/hadoop/etc/hadoop/" >> ~/.bashrc
source ~/.bashrc




#FLUME-1.9.0
cat << "EOF"
--------------------------------------------
preparation flume src env
--------------------------------------------
EOF

cd /home
wget http://apache.rediris.es/flume/1.9.0/apache-flume-1.9.0-src.tar.gz
tar -xvf apache-flume-1.9.0-src.tar.gz
cd apache-flume-1.9.0-src
mvn package -DskipTests -DsourceJavaVersion=1.8 -DtargetJavaVersion=1.8 -Dhadoop -Dhive
tar -C/opt -xvf  flume-ng-dist/target/apache-flume-1.9.0-bin.tar.gz
mv /opt/apache-flume* /opt/flume
echo "PATH=\"/opt/flume/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc


# SQOOP-1.4.7
cat << "EOF"
--------------------------------------------
preparation sqoop src env
--------------------------------------------
EOF

cd /home
yum -y install git asciidoc redhat-lsb-core xmlto
wget http://apache.rediris.es/sqoop/1.4.7/sqoop-1.4.7.tar.gz
tar -xvf sqoop-1.4.7.tar.gz
cd sqoop-1.4.7
ant tar -Dhadoop.version=3.1.1 -Dhcatalog.version=2.3.3
tar -C/opt -xvf build/sqoop-1.4.7.bin__hadoop-3.1.1.tar.gz
mv /opt/sqoop-* /opt/sqoop
cp /home/mysql-connector-java-8.0.16/mysql-connector-java-8.0.16.jar /opt/sqoop/lib/
echo "PATH=\"/opt/sqoop/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc

cat << EOF > /opt/sqoop/conf/sqoop-env.sh
export HADOOP_COMMON_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop/share/hadoop/mapreduce
export HBASE_HOME=/opt/hbase
export HIVE_HOME=/opt/hive
export ZOOCFGDIR=/opt/zookeeper/conf
EOF


# HUE 4.4.0
cat << "EOF"
--------------------------------------------
preparation sqoop src env
--------------------------------------------
EOF

# Hue
cd /home
yum -y install asciidoc cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-plain gcc gcc-c++ krb5-devel libffi-devel libtidy libxml2-devel libxslt-devel make mariadb mariadb-devel openldap-devel python-devel sqlite-devel openssl-devel gmp-devel
wget https://www.dropbox.com/s/n6uvr709ng2p2j2/hue-4.4.0.tgz
tar -xvf hue-4.4.0.tgz
cd hue-4.4.0

sed -i 's/SETUID_USER = "hue"/SETUID_USER = "root"/' desktop/core/src/desktop/supervisor.py
sed -i 's/SETGID_GROUP = "hue"/SETGID_GROUP = "root"/' desktop/core/src/desktop/supervisor.py

cat << EOF | mysql
create database hue;
grant all privileges on hue.* to 'hue'@'%' identified by 'hue';
grant all privileges on hue.* to 'hue'@'localhost' identified by 'hue';
flush privileges;
EOF

cat << EOF > desktop/conf/hue.ini
[desktop]
  secret_key=ashdofhaoirtoidfjgoianoanweorianwofinawerot
  http_host=0.0.0.0
  http_port=8000
  send_dbug_messages=true
  server_user=root
  server_group=root
  default_user=root
  default_hdfs_superuser=root
  [[auth]]
    idle_session_timeout=-1
  [[database]]
    engine=mysql
    host=localhost
    user=hue
    password=hue
    name=hue
[hadoop]
  [[hdfs_clusters]]
    [[[default]]]
      fs_defaultfs=hdfs://localhost:8020
      webhdfs_url=http://localhost:50070/webhdfs/v1
  [[yarn_clusters]]
    [[[default]]]
      resourcemanager_host=localhost
      submit_to=True
      resourcemanager_api_url=http://localhost:8088
      proxy_api_url=http://localhost:8088
EOF

INSTALL_DIR=/opt/hue make install
nohup /opt/hue/build/env/bin/supervisor 1>/dev/null 2>/dev/null &


# TEZ-0.8.4
cat << "EOF"
--------------------------------------------
preparation tez src env
--------------------------------------------
EOF

# INSTALL AND CONF TEZ
cd /home
wget http://ftp.man.poznan.pl/apache/tez/0.8.4/apache-tez-0.8.4-bin.tar.gz
tar xvzf /home/apache-tez-0.8.4-bin.tar.gz;
mv apache-tez-0.8.4-bin /opt/tez

hdfs dfs -mkdir /tez
hdfs dfs -put /home/apache-tez-0.8.4-bin.tar.gz /tez/

hdfs dfs -mkdir -p /tez/conf
hdfs dfs -mkdir -p /tez/tez




cat << EOF > /opt/tez/conf/tez-site.xml
<!--<hdfs://localhost:8020 is the value as specified in the fs.default.name property in core-site.xml>-->
<configuration>
<property>
    <name>tez.lib.uris</name>
    <value>hdfs://localhost:9000/tez/apache-tez-0.8.4-bin.tar.gz</value>
    <type>string</type>
</property>
</configuration>
EOF

# /opt/hadoop/etc/hadoop/mapred-site.xml << <property><name>mapred.framework.name</name><value>yarn-tez</value></property>


echo "export TEZ_HOME=/opt/tez" >> ~/.bashrc
echo "export PATH=/opt/tez:\$PATH" >> ~/.bashrc
source ~/.bashrc


hadoop jar $TEZ_HOME/tez-examples-0.8.4.jar orderedwordcount /path/to/sample/text/file /path/to/output/hdfs/directory


# INTEGRTING WITH HIVE
sudo cp /opt/hive/conf/hive-exec-log4j2.properties /opt/hive/conf/hive-exec-log4j2.properties
hdfs dfs -put /usr/share/hive/conf/hive-exec-log4j2.properties /tez/

hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.2.jar pi 16 1000
