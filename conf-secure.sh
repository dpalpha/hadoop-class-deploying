# Transport Security for Intermediate Data 


# 1. 

cat << EOF > /opt/hadoop/etc/hadoop/core-site.xml
<configuration>

  <property><name>hadoop.tmp.dir</name><value>/app/hadoop/tmp</value></property>
  <property><name>fs.default.name</name><value>hdfs://localhost:9000</value></property>
  
  <!--  RPC traffic encrypted with SSL -->
  <property><name>hadoop.ssl.require.client.cert</name><value>false</value><final>true</final></property>
  <property><name>hadoop.ssl.hostname.verifier</name><value>DEFAULT</value><final>true</final></property>
  <property><name>hadoop.ssl.keystores.factory.class</name><value>org.apache.hadoop.security.ssl.FileBasedKeyStoresFactory</value><final>true</final></property>
  <property><name>hadoop.ssl.server.conf</name><value>ssl-server.xml</value><final>true</final></property>
  <property><name>hadoop.ssl.client.conf</name><value>ssl-client.xml</value><final>true</final></property>

</configuration>
EOF

# 1.2

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
  
  <!--  RPC traffic encrypted with SSL -->
  <property><name>mapreduce.shuffle.ssl.enabled</name><value>true</value><final>true</final></property>

</configuration>
EOF

# 2.

# Authentication for Hadoop Web UIs

cat << EOF > $HADOOP_HOME/share/hadoop/hdfs/webapps/hdfs/WEB-INF/web.xml
....
<security-constraint><web-resource-collection><web-resource-name>Protected</web-resource-name><url-pattern>/*</url-pattern></web-resource-collection><auth-constraint><role-name>admin</role-name></auth-constraint></security-constraint>
<login-config><auth-method>BASIC</auth-method><realm-name>namenodeRealm</realm-name></login-config>
....
EOF

cat << EOF > $HADOOP_HOME/share/hadoop/hdfs/webapps/hdfs/WEB-INF/jetty-web.xml
<Configure class="org.mortbay.jetty.webapp.WebAppContext"><Get name="securityHandler"><Set name="userRealm">
 <New class="org.mortbay.jetty.security.HashUserRealm"><Set name="name">namenodeRealm</Set><Set name="config">
 <SystemProperty name="hadoop.home.dir"/>/jetty/etc/realm.properties</Set></New></Set></Get>
</Configure>
EOF

mkdir -p $HADOOP_HOME/jetty/etc

echo "<your_username>: <your_password>,admin" >> $HADOOP_HOME/jetty/etc/realm.properties

# http://localhost:50070
