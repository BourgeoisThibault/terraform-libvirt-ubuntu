# Ubuntu linux

## Getting started

This is a container for deploy and customize official Rocky linux qcow2.

This is also a specific development that include some prerequisites:
  - Have a network bridge configured
  - Want an additionnal disk (/data)
  - Must define a static ip

Public image available [here](https://hub.docker.com/r/tibhome/terraform-libvirt-ubuntu).

## Build container

Download you needed img image [here](https://cloud-images.ubuntu.com/) then copi it in image directory.

```bash
docker build --no-cache -t terraform-libvirt-ubuntu:develop .
```

## Run container

```bash
docker run --rm -it -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock terraform-libvirt-ubuntu:develop
```