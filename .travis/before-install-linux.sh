#!/bin/bash

sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
sudo apt-get update
# installing gcc-7 and g++-7 to get libstdc++-7
sudo apt-get install --yes      \
        clang-8                 \
        llvm-8-dev              \
        gcc-7                   \
        g++-7

sudo update-alternatives --install /usr/bin/gcc gcc `which gcc-7` 10
sudo update-alternatives --install /usr/bin/g++ g++ `which g++-7` 10
sudo update-alternatives --set cc /usr/bin/gcc
sudo update-alternatives --set c++ /usr/bin/g++

