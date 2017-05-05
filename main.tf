provider "digitalocean" {
}

resource "digitalocean_droplet" "jenkins" {
    image = "ubuntu-16-04-x64"
    name = "jenkins"
    region = "blr1"
    size = "512mb"

    ssh_keys = ["${var.do_ssh_ids}"]
    tags   = ["${digitalocean_tag.ci.id}"]

    provisioner "remote-exec" {
      inline = [
        "apt-get update",
        "apt-get -y install python",
      ]
      connection {
        type     = "ssh"
        private_key = "${file("${var.do_private_key}")}"
        user     = "root"
        timeout  = "2m"
      }
    }

    provisioner "local-exec" {
		command = <<EOP
cat <<EOF > hosts
[ci]
${digitalocean_droplet.jenkins.ipv4_address}
EOF
EOP
	}

	provisioner "local-exec" {
		command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root --private-key '${var.do_private_key}' -i hosts jenkins.yml"
	}
}

# Create a new tag
resource "digitalocean_tag" "ci" {
  name = "ci"
}