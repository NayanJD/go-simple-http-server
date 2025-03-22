#!/bin/bash

apt-get update

arch=$(dpkg --print-architecture)
wget -q "https://go.dev/dl/go1.23.5.linux-${arch}.tar.gz" -O go.tar.gz
tar -C /usr/local -xzf go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc

git clone https://github.com/NayanJD/go-simple-http-server.git

cd go-simple-http-server && go run src/cmd/server.go
