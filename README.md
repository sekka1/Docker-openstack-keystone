Docker-openstack-keystone
=========================

Openstack Keystone running in a docker container

# Info

Keystone version: icehouse

Ubuntu version: 14.04

Keystone admin token: 7a04a385b907caca141f

# Running this container

You can use this container in 2 ways.  The first way is to just start up the container and have a non-persistent keystone database.  The second is to mount a volume from your local computer with a keystone database to be used.

Running with a new sqlite db

    docker run -p 35357:35357 -p 5000:5000 -d garland/docker-openstack-keystone

Running with a mounted persistent sqlite db.  There is an included empty Keystone db in the keystone_db directory you can use to start off with.  The idea here is that the keystone.db file will be outside the container, so when/if the container restarts, it wont restart with the blank db.

    docker run -p 35357:35357 -p 5000:5000 -v <REPO_HOME>/keystone_db:/var/lib/keystone  -d garland/docker-openstack-keystone

# Verify if Keystone is running correctly

After starting this container with either method, you should be able to make calls to the API

Documentation: http://docs.openstack.org/api/openstack-identity-service/2.0/content/User_Operations_OS-KSADM.html

## List all users:
    curl -H "X-Auth-Token:7a04a385b907caca141f" http://<CONTAINER_IP>:35357/v2.0/users

## Create a user:
    curl -X POST \
    -H "X-Auth-Token:7a04a385b907caca141f" \
    -H "Content-type: application/json" \
    -d '{"user":{"name":"Joe","email":"joe@example.com.com","enabled":true,"password":"1234"}}' \
    http://<CONTAINER_IP>:35357/v2.0/users -v