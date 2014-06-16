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

Response:

    {"users": []}

## Create a user:
    curl -X POST \
    -H "X-Auth-Token:7a04a385b907caca141f" \
    -H "Content-type: application/json" \
    -d '{"user":{"name":"Joe","email":"joe@example.com.com","enabled":true,"password":"1234"}}' \
    http://<CONTAINER_IP>:35357/v2.0/users -v

Response:

    {
      "user": {
          "username": "Joe",
          "name": "Joe",
          "enabled": true,
          "email": "joe@example.com",
          "id": "cc63dd66e1ad4401a002d8d23ba9b0bd"
      }
    }

## Update a user's password

    curl -X POST \
    -H "X-Auth-Token:7a04a385b907caca141f" \
    -H "Content-type: application/json" \
    -d '{"passwordCredentials":{"username":"Joe","password":"new_password"}}' \
    http://<CONTAINER_IP>:35357/v2.0/users/<USER_ID>/OS-KSADM

## Delete a user

    curl -X DELETE \
    -H "X-Auth-Token:7a04a385b907caca141f" \
    -H "Content-type: application/json" \
    http://localhost:35357/v2.0/users/<USER_ID> -v

## Authenticate a user

    curl -d '{"auth":{"passwordCredentials":{"username": "Joe", "password": "1234"}}}'  \
    -H "Content-type: application/json" \
     http://localhost:35357/v2.0/tokens -v

Response:

    {
        "access": {
        "token": {
        "issued_at": "2014-06-16T22:24:26.089380",
        "expires": "2014-06-16T23:24:26Z",
        "id": "MIIDAwYJKoZIhvcNAQcCoIIC9DCCAvACAQExDTALBglghkgBZQMEAgEwggFRBgkqhkiG9w0BBwGgggFCBIIBPnsiYWNjZXNzIjogeyJ0b2tlbiI6IHsiaXNzdWVkX2F0IjogIjIwMTQtMDYtMTZUMjI6MjQ6MjYuMDg5MzgwIiwgImV4cGlyZXMiOiAiMjAxNC0wNi0xNlQyMzoyNDoyNloiLCAiaWQiOiAicGxhY2Vob2xkZXIifSwgInNlcnZpY2VDYXRhbG9nIjogW10sICJ1c2VyIjogeyJ1c2VybmFtZSI6ICJnMUBhZGIuY29tIiwgInJvbGVzX2xpbmtzIjogW10sICJpZCI6ICIyOWE0MmJmMmNkZTA0ZTkzYjZhNjliODFkZTRhYWFmYiIsICJyb2xlcyI6IFtdLCAibmFtZSI6ICJnMUBhZGIuY29tIn0sICJtZXRhZGF0YSI6IHsiaXNfYWRtaW4iOiAwLCAicm9sZXMiOiBbXX19fTGCAYUwggGBAgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAGvOUnTCqxj80p2DZk6B1Xxmb5CquleC+6mhGpkg4CfjJ+1ZcwhRo4MZQkzGH0XocvGEV6ELDl-Pw1ROchfJchSFvyBLfqLIrFbayZNkj+p-Y0KPTTM6fNcrRFbvMsZMd3K3uePX2BRtGdiNX206tY-CXcxZv7Yh2v+7wNtcmHYa-piFbWjBB5Il2QzznIjlnAwm8rvpaBmL4LWgA9cQe0wF5eLuzxZdf17p0IAr0eoT2712sMJFtyAPcXeVIgXTpm1wjr8AI3j9bvOMxO-6mwjrYKa-GIruEjot8MLt2zV6PCtYrwHGcnmJ0BjxR3nvUiopJAi7ALhTDbfWecH+A=="
      },
        "serviceCatalog": [],
        "user": {
        "username": "Joe",
        "roles_links": [],
        "id": "29a42bf2cde04e93b6a69b81de4aaafb",
        "roles": [],
        "name": "Joe"
      },
      "metadata": {
      "is_admin": 0,
      "roles": []
      }
    }
    }

The "id" is the "< AUTH_TOKEN >"

## Validate a token

Return meta data

    curl -H "X-Auth-Token:7a04a385b907caca141f" http://localhost:35357/v2.0/tokens/<AUTH_TOKEN>

Return no meta data

    curl -I -H "X-Auth-Token:7a04a385b907caca141f" http://localhost:35357/v2.0/tokens/<AUTH_TOKEN>


    