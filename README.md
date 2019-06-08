# Apache Hadoop 3.1.1 native


## Requirements

- CentOS 7, Ubuntu 18.04
- SElinux and firewalld should be disabled.
- The install.sh script should be run as root.
- set default "localhost"


## Software and versions

The script will download, compile, configure and run the following pieces of software:

- Java 8u171
- Cmake-3.6.2
- Ant 1.10.5
- Maven 3.6.1
- Protobuf 2.5
- Zookeeper 3.5.5
- Hadoop 3.1.1
- Spark 2.4.3
- Hive 3.1.1
- Pig 0.17
- HBase 2.1.4
- Flume 1.8.0
- Sqoop 1.4.7
- Hue 4.4.0
- Tez 0.8.4

## Layout

- /opt will contain installed software (each project goes into its own directory)
- /data will contain Hadoop's data
