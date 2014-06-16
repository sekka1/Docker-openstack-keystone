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

    docker run -p 35357:35357 -p 5000:5000 -v <LOCAL_REPO_HOME>/keystone_db:/var/lib/keystone -d garland/docker-openstack-keystone

# boot2docker users

Note for boot2docker users.  Remember that if you are using boot2docker docker is actually running in a VM that exposes the sock connection out to your local computer.  This means that when you mount a volume, it is not your local computer's path.  It is the path inside of the boot2docker VM.  You can follow boot2docker's instructions on how to share folders with your local computer here: https://github.com/boot2docker/boot2docker#folder-sharing

1. Or you can just keep the keystone.db file inside boot2docker.  In that case you ssh into boot2docker:

        boot2docker ssh

2. You will be placed into the directory of "/home/docker"

3. Clone out this repository there:

        git clone https://github.com/sekka1/Docker-openstack-keystone.git

4. Go back into a command prompt of your local computer and start this container.  The volume path is the path inside your boot2docker VM.

        docker run -p 35357:35357 -p 5000:5000 -v /home/docker/Docker-openstack-keystone/keystone_db:/var/lib/keystone -d garland/docker-openstack-keystone


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