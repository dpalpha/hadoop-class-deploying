#!/usr/bin/env bash

# Zookeeper
echo "ls /" | zkCli.sh

# HDFS
dd if=/dev/zero of=/tmp/test.txt bs=130M count=1
hdfs dfs -put /tmp/test.txt /tmp
hdfs dfs -ls /tmp/test.txt
hdfs dfs -rm -skipTrash /tmp/test.txt
rm -f /tmp/test.txt

# YARN and MapReduce
yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar pi 3 100

# Spark
spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --master yarn /opt/spark/examples/jars/spark-examples_2.11-2.4.3.jar 50

# HBase
hbase shell <<EOF
create 'test', 'f1'
put 'test', 'row1', 'f1', 'value1'
put 'test', 'row2', 'f1', 'value2'
put 'test', 'row3', 'f1', 'value3'
scan 'test'
disable 'test'
drop 'test'
EOF

# Hive
beeline -u "jdbc:hive2://localhost:10000/default" -nroot -e "create table test (id int); insert into test values (1), (2), (3); select count(*) from test; drop table test;"

# Pig
pig <<EOF
sh echo "bob male" > /tmp/test.txt
sh echo "james male" >> /tmp/test.txt
sh echo "jane female" >> /tmp/test.txt
sh echo "tom male" >> /tmp/test.txt
sh echo "sandra female" >> /tmp/test.txt
rmf /tmp/test.txt
copyFromLocal /tmp/test.txt /tmp/
sh rm /tmp/test.txt
a = LOAD '/tmp/test.txt' USING PigStorage(' ') AS (name, sex);
b = GROUP a by sex;
c = FOREACH b GENERATE group, COUNT(a.name);
DUMP c;
rmf /tmp/test.txt
quit; 
EOF

# Sqoop
sqoop import --connect jdbc:mysql://localhost/hive --username hive --password hive --target-dir=/tmp/test --table=DBS
hdfs dfs -rm -r -skipTrash /tmp/test

# Hue
wget -q -O - http://localhost:8000 | grep Cloudera

