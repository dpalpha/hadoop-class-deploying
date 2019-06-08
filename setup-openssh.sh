su - hduser

sudo apt-get remove openssh-server openssh-client
sudo apt-get update
sudo apt-get install openssh-server openssh-client
sudo ufw allow 22

sudo systemctl restart ssh
sudo apt-get install ssh
sudo apt-get install rsync

ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
ssh-keygen -t rsa

ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys 
sudo apt-get update
ssh localhost
