#!/bin/bash

apt-get update

arch=$(dpkg --print-architecture)

apt install -y git

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

# Clone this repo
git clone https://github.com/NayanJD/go-simple-http-server.git /root/simplehttp
