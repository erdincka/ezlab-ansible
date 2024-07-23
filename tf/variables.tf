variable "pve" {
  type        = map
  description = "PVE host information with host, username, password keys"
}

variable "settings" {
  type        = map
  description = "Settings to use specific to the environment"
}

variable "template" {
  type        = map
  description = "Proxmox specific settings with template, storage, network, bridge, eznode, hostname, firstip keys"
}

variable "eznode" {
  type        = map
  description = "Ezmeral product node types with ua_control, ua_worker, df_singlenode"
}

variable "ezua" {
  type        = map
  description = "Ezmeral UA specific settings"
}

variable "ezdf" {
  type        = map
  description = "Ezmeral DF specific settings"
}
