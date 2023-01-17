# see https://github.com/hashicorp/terraform
terraform {
  required_providers {
    # see https://registry.terraform.io/providers/hashicorp/random
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    # see https://registry.terraform.io/providers/hashicorp/template
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    # see https://registry.terraform.io/providers/dmacvicar/libvirt
    # see https://github.com/dmacvicar/terraform-provider-libvirt
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  #uri = "qemu+ssh://adminpharos@10.78.31.7/system"
  uri = "${var.qemu_uri}"
}

# see https://github.com/dmacvicar/terraform-provider-libvirt/blob/v0.7.1/website/docs/r/network.markdown
resource "libvirt_network" "terraform_network" {
  name = "${var.object_name}_net"
  mode = "bridge"
  addresses = ["${var.net_network}"]
  bridge = "${var.bridge}"
  dns {
    enabled = true
    local_only = true
  }
}

data "template_file" "cloudinit_data" {
  template = file("cloudinit.cfg")
  vars = {
    hostname = "${var.hostname}"
    user_add = "${var.user_add}"
    hash_user_pass = "${var.hash_user_pass}"
    ssh_public_key = "${var.ssh_public_key}"
    tmp_public_key_pass = file("${var.tmp_public_key_pass}")
  }
}

data "template_file" "cloudinit_network" {
  template = file("network.cfg")
  vars = {
    net_address = "${var.net_address}"
    net_mask = "${var.net_mask}"
    net_gateway = "${var.net_gateway}"
  }
}

# create a cloud-init cloud-config.
resource "libvirt_cloudinit_disk" "cloudinit_creation" {
  name = "${var.object_name}_cloudinit.iso"
  user_data      = data.template_file.cloudinit_data.rendered
  network_config = data.template_file.cloudinit_network.rendered
}

resource "libvirt_volume" "volume_root" {
  name = "${var.object_name}_root.img"
  pool = "${var.vm_location_folder}" # List storage pools using virsh pool-list
  source = "${var.image_source}"
  format = "qcow2"
}

# a data disk.
# see https://github.com/dmacvicar/terraform-provider-libvirt/blob/v0.7.1/website/docs/r/volume.html.markdown
resource "libvirt_volume" "volume_data" {
  name = "${var.object_name}_data.img"
  pool = "${var.vm_location_folder}" # List storage pools using virsh pool-list
  format = "qcow2"
  size = var.data_disk_size*1024*1024*1024 
}

# see https://github.com/dmacvicar/terraform-provider-libvirt/blob/v0.7.1/website/docs/r/domain.html.markdown
resource "libvirt_domain" "kvm_creation" {
  name = "${var.object_name}"
  cpu {
    mode = "host-passthrough"
  }
  vcpu = "${var.vm_cpu}"
  memory = "${var.vm_memory}"
  qemu_agent = true
  cloudinit = libvirt_cloudinit_disk.cloudinit_creation.id
  disk {
    volume_id = libvirt_volume.volume_root.id
    scsi = true
  }
  disk {
    volume_id = libvirt_volume.volume_data.id
    scsi = true
  }
  network_interface {
    network_id = libvirt_network.terraform_network.id
    addresses = ["${var.net_address}"]
  }
  provisioner "remote-exec" {
    inline = [
      <<-EOF
      set +x
      # Remove temp authorized key
      echo '${var.ssh_public_key}' > /home/${var.user_add}/.ssh/authorized_keys
      while ! grep "Cloud-init .* finished" /var/log/cloud-init.log; do
        echo "$(date -Ins) Waiting for cloud-init to finish"
        sleep 2
      done
      # Execute some commands as created user HERE
      EOF
    ]
    connection {
      type = "ssh"
      user = "${var.user_add}"
      host = "${var.net_address}"
      private_key = file("${var.tmp_private_key_pass}")
    }
  }
}
