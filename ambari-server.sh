# hadoop-ambari-hdp3
### OS UBUNTU-18 

### Step 1.Setup environment::
 Switch to "root" user
  sudo su root
 
### Step 2.Install and setup SSH server::
  apt-get install ssh
  vi /etc/ssh/sshd_config
  In sshd_config file set PermitRootLogin to Yes. Save and exit. Restart ssh service.
 service ssh restart

### Step 3: Install JDK::
 add-apt-repository ppa:webupd8team/java
 apt-get update
 apt-get install oracle-java8-installer

### Step 4: Verify/Check Java installation::
 apt-get install oracle-java8-set-default
 java -version

### Step 5: Add JAVA_HOME::
 echo "JAVA_HOME=/uer/lib/jvm/java-8-oracle" >> /etc/environment 
 echo "JRE_HOME=/usr/lib/jvm/java-8-oracle/jre" >> /etc/environment

 Also make sure to add JAVA_HOME to command line so that Ambari installation will be able to use it.
### Step 6 :Change hostname and setup FQDN:
 cat /etc/hostname
 ip addr show
 echo "root-ambarisvr.com" >> /etc/hostname
 vim /etc/hosts 

 After the hosts file is edited, set up the machine hostname:

 hostname root-ambarisvr.com
 
 In our case that would be:
 hostname yoda-ambarisvr.com
 
 Hostname now should match to entered names in “hostname” and “hosts” files.
### Step 7: Generate SSH keys::
 ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
 
Try to ssh with the newly created keys:

  ssh root@yoda-ambarisvr.com

### Step 8: Disable firewall::
 Check firewall status:
  sudo ufw status
  
If the firewall is active, turn it off:

 sudo ufw disable 

### Step 9: Stop SELinux::
 apparmor_status
 /etc/init.d/apparmor stop

### Step 10: Add Ambari Repository::
 ubuntu18:
  wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/...
 
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
 if you get GPG error, and signatures as invalid, do the below 
 manually update "/etc/apt/sources.list.d/ambari.list 
  and add [trusted=yes] in the second line after the word "deb"

### Step 11:
 apt-get update 
 apt-cache showpkg ambari-server 
 apt-cache showpkg ambari-agent
 apt-cache showpkg ambari-metrics-assembly

### Step 12: Install Ambari, Start, Verify and Launch the Ambari UI::
 apt-get install ambari-server (size will be 758MB , will download postgresql, Python, curl etc)
 ambari-server setup
 ambari-server start
 ambari-server status
