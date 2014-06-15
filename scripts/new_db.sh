#!/bin/bash

export OS_SERVICE_TOKEN=7a04a385b907caca141f
export OS_SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0

# Change admin key in keystone conf file
sed 's/#admin_token=ADMIN/admin_token=7a04a385b907caca141f/g' -i /etc/keystone/keystone.conf

supervisorctl restart keystone

# Create keystone admin user
#keystone --os-username=admin --os-password=$OS_SERVICE_TOKEN \
#  --os-auth-url=http://controller:35357/v2.0 token-get

# exporting admin creds
#export OS_USERNAME=admin
#export OS_PASSWORD=$OS_SERVICE_TOKEN
#export OS_TENANT_NAME=admin
#export OS_AUTH_URL=http://127.0.0.1:35357/v2.0

# Define services and API endpoints per doc: http://docs.openstack.org/icehouse/install-guide/install/apt/content/keystone-services.html
#keystone service-create --name=keystone --type=identity \
#  --description="OpenStack Identity"

#keystone endpoint-create \
#  --service-id=$(keystone service-list | awk '/ identity / {print $2}') \
#  --publicurl=http://127.0.0.1:5000/v2.0 \
#  --internalurl=http://127.0.0.1:5000/v2.0 \
#  --adminurl=http://127.0.0.1:35357/v2.0


#
# sqlite db location
#
connection = sqlite:////var/lib/keystone/keystone.db

