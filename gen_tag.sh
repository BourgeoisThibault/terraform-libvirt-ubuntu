#!/bin/bash

REPO="tibhome"
IMAGE="terraform-libvirt-ubuntu"
VERSION="22.04-1"

docker build --no-cache -t ${REPO}/${IMAGE}:${VERSION} .

docker push ${REPO}/${IMAGE}:${VERSION}