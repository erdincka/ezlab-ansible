# userdata
#cloud-config
hostname: {hostname}
manage_etc_hosts: true
fqdn: {fqdn}
user: {ssh_username}
password: {ssh_password}
ssh_authorized_keys:
  - {ssh_pubkey}
chpasswd:
  list: |
    {ssh_username}:{ssh_password}
    root:{ssh_password}
  expire: False
ssh_pwauth: true
disable_root: false


# metadata
instance-id: {hostname}
local-hostname: {hostname}


# network-config
config:
  - type: physical
    name: {interface}
    subnets:
      - type: static
        address: {ip_address}/{network_bits}
        gateway: {gateway}
        dns_nameservers:
          - {nameserver}
        dns_search:
         - {searchdomain}
