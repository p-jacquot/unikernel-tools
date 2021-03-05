#! /bin/bash

# This script install hermitux inside this repo.

sudo ./../hermitcore/install.sh

git clone https://github.com/ssrg-vt/hermitux
cd ./hermitux
git submodule update --init
make

