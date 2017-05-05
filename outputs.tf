output "address_web" {
    value = "${digitalocean_droplet.jenkins.ipv4_address}"
}