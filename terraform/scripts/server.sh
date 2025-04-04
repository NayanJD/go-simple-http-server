#!/bin/bash

apt-get update
apt install -y btop

arch=$(dpkg --print-architecture)
wget -q "https://go.dev/dl/go1.23.5.linux-${arch}.tar.gz" -O go.tar.gz
tar -C /usr/local -xzf go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc

export PATH=$PATH:/usr/local/go/bin

git clone https://github.com/NayanJD/go-simple-http-server.git /root/simplehttp

# cd go-simple-http-server && go run src/cmd/server.go
