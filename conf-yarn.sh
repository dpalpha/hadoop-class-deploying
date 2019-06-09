



cat << EOF > /opt/hadoop/etc/hadoop/yarn-site.xml
<configuration>
  <property><name>yarn.resourcemanager.hostname</name><value>localhost</value></property>
  
  <!- Configuring SSL Transport Security for YARN-->
  <!--the https address of the RM web application-->
  <property><name>yarn.resourcemanager.webapp.https.address</name><value>${yarn.resourcemanager.hostname}:8090</value></property>
  
  <!--enforces the HTTPS endpoint only for all Yarn Daemons-->
  <property><name>yarn.http.policy</name><value>HTTPS_ONLY</value></property>
  <!--enable Kill Application control in the RM web application-->
  <property><name>yarn.resourcemanager.webapp.ui-actions.enabled</name><value>true</value></property>
  
  <!--the class to use as the FairScheduler .-->
  <!--===================================== .-->
  <property><name>yarn.resourcemanager.scheduler.class</name><value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value></property>
  
  <!--path to allocation file describing queues and their properties-->
  <property><name>yarn.scheduler.fair.allocation.file</name><value>fair-scheduler.xml</value></property>
  
  <!--the class to use as the CapacityScheduler .-->
  <property><name>yarn.resourcemanager.scheduler.class</name><value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value><property>
  
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

cat << EOF > /opt/hadoop/etc/hadoop/fair-scheduler.xml
<?xml version="1.0"?>
<allocations>
 <queue name="Queue1"><minResources>10000 mb,0vcores</minResources><maxResources>90000 mb,0vcores</maxResources><maxRunningApps>50</maxRunningApps>
 <maxAMShare>0.1</maxAMShare><weight>2.0</weight><schedulingPolicy>fair</schedulingPolicy></queue>
 
 <queue name="Queue2"><minResources>5000 mb,0vcores</minResources><maxResources>40000 mb,0vcores</maxResources><maxRunningApps>100</maxRunningApps>
 <maxAMShare>0.1</maxAMShare><weight>1.0</weight><schedulingPolicy>fair</schedulingPolicy></queue>
</allocations>
</xml>
EOF

cat << EOF > /opt/hadoop/etc/hadoop/capacity-scheduler.xml
<?xml version="1.0"?>
<configuration>
 <property><name>yarn.scheduler.capacity.root.queues</name><value>prod,dev,default</value></property>
 <property><name>yarn.scheduler.capacity.root.prod.capacity</name><value>20</value></property>
 <property><name>yarn.scheduler.capacity.root.dev.capacity</name><value>40</value></property>
 <property><name>yarn.scheduler.capacity.root.default.capacity</name><value>40</value></property>
 <property><name>yarn.scheduler.capacity.root.dev.maximum-capacity</name><value>75</value></property>
 <property><name>yarn.scheduler.capacity.queue-mappings</name><value>u:devuser:dev,u:produser:prod</value></property>
</configuration>
EOF
