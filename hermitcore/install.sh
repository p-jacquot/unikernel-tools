#! /bin/bash

# This script install HermitCore's toolchain in the /opt/hermit/ directory.
# You need to be root if you want the installation to be successfull !

apt-get update
apt-get install -y git build-essential cmake nasm apt-transport-https wget libgmp-dev bsdmainutils libseccomp-dev python libelf-dev

echo "deb [trusted=yes] https://dl.bintray.com/hermitcore/ubuntu bionic main" >> /etc/apt/sources.list
apt-get update
apt-get install -y binutils-hermit newlib-hermit pte-hermit gcc-hermit libomp-hermit libhermit


