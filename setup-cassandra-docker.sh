
# pull docker images with registry cassandra
sudo docker pull cassandra

# run one container and name it
sudo docker run --name cass1 -d cassandra:3.0

# run other containre and connect to create cassandra cluster of two nodes
sudo docker run --name  cass2  -d -e CASSANDRA_SEEDS="$(sudo docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cass1)" cassandra:3.0

#
sudo docker exec -it cass1 nodetool status

sudo docker ps

sudo docker inspect cass1 | grep IPAddress
sudo docker exec -it cass1 cqlsh 172.17.0.2
sudo docker exce -it cassandra-cass1 nodetool status
