#!/bin/bash

apt-get update

arch=$(dpkg --print-architecture)

# Get and install nerdctl
wget -q "https://github.com/containerd/nerdctl/releases/download/v1.7.5/nerdctl-full-1.7.5-linux-${arch}.tar.gz"
tar Cxzf /usr/local "nerdctl-full-1.7.5-linux-${arch}.tar.gz"
nerdctl --version
