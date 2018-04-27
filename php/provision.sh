sudo apt-get update

# install filebeat
# see https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html
cd /tmp
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-amd64.deb
sudo dpkg -i filebeat-6.2.4-amd64.deb
sudo cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
sudo cp /vagrant/filebeat.yml /etc/filebeat/filebeat.yml
sudo update-rc.d filebeat defaults 95 10
sudo /etc/init.d/filebeat start

# install php app
sudo apt-get install -y php7.1 composer
cd /vagrant && composer install
mkdir /vagrant/log
