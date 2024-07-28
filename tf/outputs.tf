output "ua_nodes" {
  description = "ua node name=ip pairs"
  value = {
    for node in concat(proxmox_vm_qemu.ua_controllers, proxmox_vm_qemu.ua_workers):
      node.name => node.default_ipv4_address
  }
}

output "df_nodes" {
  description = "IPs for Data Fabric VMs"
  value       = {
    for node in proxmox_vm_qemu.datafabric:
      node.name => node.default_ipv4_address
  }
}
