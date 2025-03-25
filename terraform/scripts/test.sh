#!/bin/bash

apt-get update
apt install -y docker.io build-essential libssl-dev git zlib1g-dev btop

arch=$(dpkg --print-architecture)

# Install go
wget -q "https://go.dev/dl/go1.23.5.linux-${arch}.tar.gz" -O go.tar.gz
tar -C /usr/local -xzf go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc

# Install wrk
git clone https://github.com/giltene/wrk2.git
pushd wrk2
make
# move the executable to somewhere in your PATH
cp wrk /usr/local/bin
popd
