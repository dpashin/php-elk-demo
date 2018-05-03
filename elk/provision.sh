#!/bin/sh
set -e

## install Java
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | \
  sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
  sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install oracle-java8-installer

## install elasticsearch
## recipe: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install elasticsearch

sudo echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
sudo iptables -I INPUT -p tcp --dport 9200 -j ACCEPT
sudo iptables-save
sudo /etc/init.d/elasticsearch start

## install kibana 6.
## recipe: https://www.elastic.co/guide/en/kibana/current/deb.html
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo sudo DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install kibana
sudo echo "server.host: "0.0.0.0"" >> /etc/kibana/kibana.yml
sudo /etc/init.d/kibana start

## install logstash
echo 'deb http://packages.elasticsearch.org/logstash/2.0/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
sudo apt-get update
sudo sudo DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install logstash

## set default index pattern

sudo apt-get -y install jq
url="http://localhost:5601"
index_pattern="filebeat-*"
time_field="@timestamp"
# Create index pattern and get the created id
# curl -f to fail on error
id=$(curl -f -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "$url/api/saved_objects/index-pattern" \
  -d"{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"$time_field\"}}" \
  | jq -r '.id')
# Create the default index
curl -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
  "$url/api/kibana/settings/defaultIndex" \
  -d"{\"value\":\"$id\"}"
