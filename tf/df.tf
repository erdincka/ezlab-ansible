resource "proxmox_vm_qemu" "datafabric" {
  count = var.eznode.datafabric.count
  name  = "${var.template.nameprefix}${var.template.startip == "dhcp" ? var.eznode.ua_control.count + var.eznode.ua_worker.count + count.index : var.eznode.ua_control.count + var.eznode.ua_worker.count + var.template.startip + count.index}"

  desc        = "Datafabric node by ezlab"
  target_node = var.pve.node

  clone      = var.template.template
  full_clone = false

  # The destination resource pool for the new VM
  # pool = var.template.pool

  vmid   = 0
  bios   = "ovmf"
  onboot = true
  tablet = false
  agent  = 1
  scsihw = "virtio-scsi-single"
  cores  = var.eznode.datafabric.cores
  memory = var.eznode.datafabric.memGB * 1024

  ssh_user        = var.settings.username
  ssh_private_key = var.settings.private_key

  os_type      = "cloud-init"
  ipconfig0    = var.template.startip == "dhcp" ? "ip=dhcp" : "ip=${cidrhost(var.settings.cidr, var.eznode.ua_control.count + var.eznode.ua_worker.count + var.template.startip + count.index)}/${split("/", var.settings.cidr)[1]},gw=${var.settings.gateway}"
  skip_ipv6    = true
  ciuser          = var.settings.username
  cipassword      = var.settings.password
  searchdomain = var.settings.domain
  nameserver   = var.settings.nameserver
  sshkeys      = data.tls_public_key.private_key_pem.public_key_openssh

  network {
    model  = "virtio"
    bridge = var.template.bridge
  }

  efidisk {
    efitype = "4m"
    storage = var.template.os_storage
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size       = var.eznode.datafabric.os_disk_size
          iothread   = true
          storage    = var.template.os_storage
          asyncio    = "io_uring"
          cache      = "unsafe"
          discard    = true
          emulatessd = true
          backup     = false
        }
      }
      scsi1 {
        disk {
          size       = var.eznode.datafabric.data_disk_size
          iothread   = true
          storage    = var.template.data_storage
          asyncio    = "io_uring"
          cache      = "unsafe"
          discard    = true
          emulatessd = true
          backup     = false
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.template.os_storage
        }
      }
    }
  }

  connection {
    type        = "ssh"
    user        = self.ssh_user
    private_key = self.ssh_private_key
    host        = self.ssh_host
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "ip a"
  #   ]
  # }
}

resource "ansible_host" "datafabric" {
  count = var.eznode.datafabric.count
  name  = proxmox_vm_qemu.datafabric[count.index].name

  groups = [ansible_group.datafabric.name]

  variables = {
    ansible_host = proxmox_vm_qemu.datafabric[count.index].default_ipv4_address
  }
}
