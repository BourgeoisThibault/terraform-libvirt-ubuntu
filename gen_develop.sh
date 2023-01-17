#!/bin/bash

REPO="tibhome"
IMAGE="terraform-libvirt-ubuntu"
VERSION="develop"

docker build --no-cache -t ${REPO}/${IMAGE}:${VERSION} .

docker push ${REPO}/${IMAGE}:${VERSION}