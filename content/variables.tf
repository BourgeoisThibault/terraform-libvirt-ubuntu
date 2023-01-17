variable "qemu_uri" {
  type        = string
  description = "Uri for qemu connection"
  default     = "qemu:///system"
}

variable "object_name" {
  type        = string
  description = "Name of created object"
  default     = "terraform_libvirt_ubuntu"
}

variable "hostname" {
  type        = string
  description = "Hostname of the machine"
  default     = "terraform_libvirt_ubuntu"
}

variable "bridge" {
  type        = string
  description = "Name of bridge connector"
  default     = "virbr0"
}

variable "net_address" {
  type        = string
  description = "Network address"
  default     = "192.168.122.111"
}

variable "net_gateway" {
  type        = string
  description = "Network gateway"
  default     = "192.168.122.1"
}

variable "net_network" {
  type        = string
  description = "Network address (format: X.X.X.0/XX)"
  default     = "192.168.122.0/24"
}

variable "net_mask" {
  type        = string
  description = "Network mask (format: XX)"
  default     = "24"
}

variable "user_add" {
  type        = string
  description = "Hash for created user"
  default     = "administrator"
}

variable "hash_user_pass" {
  type        = string
  description = "Hash for created user"
  # cmd: `openssl passwd -6` (default password)
  default     = "$6$BYq.2zjKRMTQgfzX$AdDm5tgcCUw2cdvAFzatpQeRsmC4ds/FLhCNrd2yvKpiUj4KJPzCU1zCHrP9aRz4uowbpG6GzbZXo7R1qu.uL1"
}

variable "hash_root_pass" {
  type        = string
  description = "Hash for root user"
  # cmd: `openssl passwd -6` (default password)
  default     = "$6$BYq.2zjKRMTQgfzX$AdDm5tgcCUw2cdvAFzatpQeRsmC4ds/FLhCNrd2yvKpiUj4KJPzCU1zCHrP9aRz4uowbpG6GzbZXo7R1qu.uL1"
}

variable "ssh_public_key" {
  type        = string
  description = "Your public ssh key inline"
  default     = "ssh-rsa your_personnal_public_key"
}

variable "tmp_private_key_pass" {
  type        = string
  description = "Path for private temp ssh key"
  default     = "/root/.ssh/id_rsa"
}
variable "tmp_public_key_pass" {
  type        = string
  description = "Path for public temp ssh key"
  default     = "/root/.ssh/id_rsa.pub"
}

variable "vm_location_folder" {
  type        = string
  description = "Location folder for qcow2"
  default     = "default"
}

variable "image_source" {
  type        = string
  description = "Base img location"
  default     = "/DATA/image/jammy-server-cloudimg-amd64.img"
}

variable "vm_cpu" {
  type        = string
  description = "Number of CPU"
  default     = "2"
}

variable "vm_memory" {
  type        = string
  description = "Memory size"
  default     = "4096"
}

variable "data_disk_size" {
  type        = number
  description = "Data disk size in Gb"
  default     = "50"
}