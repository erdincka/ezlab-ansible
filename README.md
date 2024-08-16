# Install EDF and EzUA

Ezmeral Data Fabric is pre-requisites for Ezmeral Unified Analytics as of v1.5.

So we are installing Data Fabric first, and then Unified Analytics.

First, create inventory.ini file using to this template, changing as needed.

Use IP addresses (makes scripting easier)

```ini
[datafabric]
x.x.x.11

[ua_controllers]
x.x.x.12
x.x.x.13

[ua_workers]
x.x.x.14
x.x.x.15
x.x.x.16

[ua:children]
ua_controllers
ua_workers

[all:vars]
ansible_user=ezmeral
; provide credentials here or with -k command line option
; ansible_ssh_private_key_file=~/ezlab-key
; ansible_ssh_pass=Admin123.

cidr=x.x.x.0/24
gateway=x.x.x..1
domain=ezmeral.lab
nameserver=x.x.x.1
timezone=Europe/London

proxy=http://x.x.x.1:3128/
yumrepo=http://x.x.x.2/yum/
epelrepo=http://x.x.x.2/epel/8/

[datafabric:vars]
df_core_version=7.8.0
df_mep_version=9.3.0

df_clustername=datafabric
; fix as needed, have to be unformatted raw disk, no partition, no filesystem
df_disks=/dev/sdb
; change at will
df_username=mapr
df_password=mapr
df_repo=http://x.x.x.2/mapr

[ua:vars]
ua_username=admin
ua_password=Admin123.
ua_clustername=ua
registryUrl=x.x.x.2:5000/ezmeral/
registryInsecure=true
registryCaFile=
registryUsername=
registryPassword=

ezfabricctl=/usr/local/bin/ezfabricctl
ezfabrelease=/tmp/ezfab-release.tgz

```

Then you can start installation using:

`ansible-playbook -i inventory.ini install-ua.yml`

If using password to login (and not an SSH private_key):

`ansible-playbook -k -i inventory.ini --extra-vars="@demo.json" install-ua.yml`

When you see the "Install DF using stanza" task, you may follow the installation progress for DF on https://<datafabric node>:9443/ using username: mapr and password: mapr. That step takes ~30 minutes to complete.

Once the playbook is finished, you should use the EZUA Installer UI to proceed and complete the installation with the provided parameters for each page.

Assuming you have the software, you can start the installer using `./start-ezua-installer-ui.sh` script.

You may also use individual playbooks if you want. 

./install-df.yml will only install Data Fabric

./playbooks/ua/install.yml will only install Unified Analytics (assuming DF is already installed and running)
