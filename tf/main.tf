data "tls_public_key" "private_key_pem" {
  private_key_openssh = var.settings.private_key
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
