# Create an instance
resource "openstack_compute_instance_v2" "server" {
  name            = "number-one"  #Instance name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = var.keypair
  security_groups = var.security_groups

  network {
    name = var.network
  }
}

# Add floating IP (FIP)
resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.public_network
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.server.id
}

# Output private IP of instance
output "server_private_ip" {
 value = openstack_compute_instance_v2.server.access_ip_v4
}

# Output public IP of instance
output "server_floating_ip" {
 value = openstack_networking_floatingip_v2.fip.address
}
