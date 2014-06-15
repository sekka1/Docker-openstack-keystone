Docker-openstack-keystone
=========================

Openstack Keystone running in a docker container


Running with a new sqlite db
    docker run -i -t  -p 35357:35357 -p 5000:5000

Running with a mounted persistent sqlite db
    docker run -i -t  -p 35357:35357 -p 5000:5000 -v /home/docker:/var/lib/keystone  garland/docker-openstack-keystone