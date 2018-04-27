# SUMMARY

Demo environment with two boxes: 
* elkhost: installed elk 6.x
* phphost: installed php and filebeat. writes logs to elkhost.

# INSTALL

    cd elk
    vagrant up
    cd ../
    cd php
    vagrant up

## USAGE

### write some logs on phphost 

    # ssh to box
    cd php
    vagrant ssh
    
    # write some logs
    php /vagrant/write.php && tail /vagrant/log/demo.log

    # check filebeat logs
    sudo tail -n 100 /var/log/filebeat/filebeat
    
### check logs on root host:

* [http://localhost:5601/](http://localhost:5601/) - Kibana

* [http://localhost:9200/](http://localhost:9200/) - ElasticSearch
  * [list indices](http://localhost:9200/_cat/indices)
  * put document
    ````
    curl -X POST 'http://localhost:9200/demoapp/helloworld/1' -d '{ "message": "Hello World!" }' -H 'Content-Type: application/json'
    ````
## TROUBLESHOOTING

### proxy blocks downloading base vagrant image

recipe: https://stackoverflow.com/questions/28399324/download-vagrant-box-file-locally-from-atlas-and-configuring-it
tldr:

    wget https://app.vagrantup.com/ubuntu/boxes/xenial64/versions/20180419.0.0/providers/virtualbox.box
    vagrant box add --name="ubuntu/xenial64" file:///C:/dev/boxes/xenial-server-cloudimg-amd64-vagrant.box 
