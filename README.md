# Ubuntu linux

## Getting started

This is a container for deploy and customize official Rocky linux qcow2.

This is also a specific development that include some prerequisites:
  - Have a network bridge configured
  - Want an additionnal disk (/data)
  - Must define a static ip

Public image available [here](https://hub.docker.com/r/tibhome/terraform-libvirt-ubuntu).

If with AppArmor security system, add this in `/etc/apparmor.d/libvirt/TEMPLATE.qemu` and restart `libvirtd` service.

```bash
#
# This profile is for the domain whose UUID matches this file.
#

#include <tunables/global>

profile LIBVIRT_TEMPLATE flags=(attach_disconnected) {
   /var/lib/libvirt/images/**.qcow2 rwk,
   /var/lib/libvirt/images/**.raw rwk,
   /var/lib/libvirt/images/**.img rwk,
   /var/lib/libvirt/images/**.iso rwk,
  #include <abstractions/libvirt-qemu>
}
```

## Build container

Download you needed img image [here](https://cloud-images.ubuntu.com/) then copi it in image directory.

```bash
docker build --no-cache -t terraform-libvirt-ubuntu:develop .
```

## Run container

```bash
docker run --rm -it -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock terraform-libvirt-ubuntu:develop
```
