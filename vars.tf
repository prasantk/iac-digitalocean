//variable "do_ssh_fingerprint" {}

//variable "do_pub_key" {}

variable "do_private_key" {
    default = "~/.ssh/digitalocean_id_rsa"
}

variable "do_ssh_ids" {
  type = "list"
}