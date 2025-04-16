#!/bin/bash

apt-get update
apt install -y docker.io build-essential libssl-dev git zlib1g-dev btop

# Add docker GPG and repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
apt-get update

# Install containerd
apt install -y containerd

arch=$(dpkg --print-architecture)

# Get and install nerdctl
wget -q "https://github.com/containerd/nerdctl/releases/download/v1.7.5/nerdctl-full-1.7.5-linux-${arch}.tar.gz"
tar Cxzf /usr/local "nerdctl-full-1.7.5-linux-${arch}.tar.gz"
nerdctl --version

echo 'alias n="nerdctl"' >>~/.bashrc

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

# Clone this repo
git clone https://github.com/NayanJD/go-simple-http-server.git /root/simplehttp
