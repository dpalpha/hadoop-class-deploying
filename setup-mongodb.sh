
# Pdownload packages Mongo
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.6.12.tgz

# unpacking
tar -zxvf mongodb-linux-x86_64-ubuntu1604-3.6.12.tgz

# open binary 
cd mongodb-linux-x86_64-ubuntu1604-3.6.12/bin

# create data source
mkdir db

# run serwer mongo with data sources
./mongod --dbpath db

#### open terminal Mongo

cd mongodb-linux-x86_64-ubuntu1604-3.6.12/bin
./mongo
