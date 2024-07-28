terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.pve.host}:8006/api2/json"
  pm_user = "${var.pve.username}"
  pm_password = "${var.pve.password}"
  pm_tls_insecure = true
  pm_log_enable = true
  pm_debug = true
}

data "tls_public_key" "private_key_pem" {
  private_key_openssh = file(pathexpand("~/.ssh/id_rsa"))
}

resource "ansible_group" "ua_controllers" {
  name = "ua_controllers"
  variables = {
    ansible_user = "${var.settings.username}"
    settings = jsonencode(var.settings)
    ezua = jsonencode(var.ezua)
  }
}

resource "ansible_group" "ua_workers" {
  name = "ua_workers"
  variables = {
    ansible_user = "${var.settings.username}"
    settings = jsonencode(var.settings)
    ezua = jsonencode(var.ezua)
  }
}

resource "ansible_group" "datafabric" {
  name = "datafabric"
  variables = {
    ansible_user = "${var.settings.username}"
    settings = jsonencode(var.settings)
    ezdf = jsonencode(var.ezdf)
  }
}
