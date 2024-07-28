resource "proxmox_vm_qemu" "ua_controllers" {
  count = var.eznode.ua_control.count
  name  = "${var.template.nameprefix}${var.template.startip == "dhcp" ? count.index : var.template.startip + count.index}"

  desc        = "UA controlplane node by ezlab"
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
  cores  = var.eznode.ua_control.cores
  memory = var.eznode.ua_control.memGB * 1024

  ssh_user        = var.settings.username
  ciuser          = var.settings.username
  cipassword      = var.settings.password

  os_type      = "cloud-init"
  ipconfig0    = var.template.startip == "dhcp" ? "ip=dhcp" : "ip=${cidrhost(var.settings.cidr, var.template.startip + count.index)}/${split("/", var.settings.cidr)[1]},gw=${var.settings.gateway}"
  skip_ipv6    = true
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
          size       = var.eznode.ua_control.os_disk_size
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
          size       = var.eznode.ua_control.data_disk_size
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

  # connection {
  #   type        = "ssh"
  #   user        = self.ssh_user
  #   private_key = self.ssh_private_key
  #   host        = self.ssh_host
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "ip a"
  #   ]
  # }

  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${self.ssh_user} --limit '${self.default_ipv4_address}' --private-key ${self.ssh_private_key}' apache-install.yml"
  # }

}

resource "proxmox_vm_qemu" "ua_workers" {
  count = var.eznode.ua_worker.count
  name  = "${var.template.nameprefix}${var.template.startip == "dhcp" ? var.eznode.ua_control.count + count.index : var.template.startip + count.index + var.eznode.ua_control.count}"

  desc        = "UA controlplane node by ezlab"
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
  cores  = var.eznode.ua_worker.cores
  memory = var.eznode.ua_worker.memGB * 1024

  ssh_user        = var.settings.username
  ciuser          = var.settings.username
  cipassword      = var.settings.password

  os_type      = "cloud-init"
  ipconfig0    = var.template.startip == "dhcp" ? "ip=dhcp" : "ip=${cidrhost(var.settings.cidr, var.template.startip + count.index + var.eznode.ua_control.count)}/${split("/", var.settings.cidr)[1]},gw=${var.settings.gateway}"
  skip_ipv6    = true
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
          size       = var.eznode.ua_worker.os_disk_size
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
          size       = var.eznode.ua_worker.data_disk_size
          iothread   = true
          storage    = var.template.data_storage
          asyncio    = "io_uring"
          cache      = "unsafe"
          discard    = true
          emulatessd = true
          backup     = false
        }
      }
      scsi2 {
        disk {
          size       = var.eznode.ua_worker.data_disk_size
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

}

resource "ansible_host" "controller" {
  count = var.eznode.ua_control.count
  name  = proxmox_vm_qemu.ua_controllers[count.index].name

  groups = [ansible_group.ua_controllers.name]

  variables = {
    ansible_host = proxmox_vm_qemu.ua_controllers[count.index].default_ipv4_address
  }
}

resource "ansible_host" "worker" {
  count = var.eznode.ua_worker.count
  name  = proxmox_vm_qemu.ua_workers[count.index].name

  groups = [ansible_group.ua_workers.name]

  variables = {
    ansible_host = proxmox_vm_qemu.ua_workers[count.index].default_ipv4_address
  }
}