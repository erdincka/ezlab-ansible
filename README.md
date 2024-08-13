# Install EDF and EzUA

Ezmeral Data Fabric is pre-requisites for Ezmeral Unified Analytics as of v1.5.

So we are installing Data Fabric first, and then Unified Analytics.

We assume you have created your nodes/VMs that has SSH password or public key authentication enabled. If you haven't enabled passwordless sudo, please run the ansible command with -K option so it will ask for sudo password.

You will need to define your infrastructure details in a JSON file, let's call it `demo.json` but you can name it anything.

`demo.json` has the following schema:

```json

{
    "settings": {
        "cidr": "<ip address>/24",
        "gateway": "<ip address>",
        "nameserver": "<ip address>",
        "domain": "domain.tld",
        "proxy": "http://<ip address>:<port>/",
        "username": "<user with sudo rights to target nodes/VMs>",
        "password": "<password>",
        "timezone": "Europe/London", // or anything else from TZ database
        "yumrepo": "<full URL to the RPM repository containing the folder 8/>",
        "epelrepo": "<full URL to the EPEL repository containing repodata/repomd.xml file"
    },
    "ezua": {
        "username": "admin", // default admin user
        "password": "Admin123.", // change as you wish
        "clustername": "ua", // name of the cluster which will be accessible at https://home.<clustername>.<domain>
        "registryUrl": "<registry project path>/", // should end with /
        "registryInsecure": true,
        "registryCaFile": "",
        "registryUsername": "",
        "registryPassword": ""
    },
    "ezdf": {
        "cluster_name": "df",
        "user": "mapr",
        "password": "mapr123", // change as you like
        "disks": "/dev/sdb", // ensure correct disks are selected, use sudo fdisk -l to list all unallocated disks, comma separated
        "repo": "<full URL to the MapR repository with v7.8.0/ and MEP/MEP-9.3.0/ folders"
    }
}

```

Then create inventory.ini file using to this template, changing user, private key file and paths to ezfabricctl and ezfab-release.tgz files. 

Use IP addresses for the hosts and not hostname or fqdn.

```yaml

[all:vars]
ansible_user=<ssh username>
ansible_ssh_private_key_file=~/ezlab-key
ezfabricctl=/usr/local/bin/ezfabricctl
ezfabrelease=/tmp/ezfab-release.tgz

[datafabric]
<ip address>

[ua_controllers]
<ip address of controller>
<ip address of k8s master>

[ua_workers]
# 3 or more
<ip address of k8s worker>
<ip address of k8s worker>
<ip address of k8s worker>

[ua:children]
ua_controllers
ua_workers

```

Then you can start installation using:

`ansible-playbook -i inventory.ini --extra-vars="@demo.json" install-ua.yml`

Replace @demo.json with the correct filename if needed.

If using password to login (and not an SSH private_key):

`ansible-playbook -k -i inventory.ini --extra-vars="@demo.json" install-ua.yml`

If ssh user doesn't have passwordless sudo, run the command with -K param:

`ansible-playbook -kK -i inventory.ini --extra-vars="@demo.json" install-ua.yml`

When you see the "Install DF using stanza" task, you may follow the installation progress for DF on https://<datafabric node>:9443/ using username: mapr and password: mapr. That step takes ~30 minutes to complete.

Once the playbook is finished, you should use the EZUA Installer UI to proceed and complete the installation with the provided parameters for each page.

You may also use individual playbooks if you want. 

./install-df.yml will only install Data Fabric

./playbooks/ua/install.yml will only install Unified Analytics (assuming DF is already installed and running)

