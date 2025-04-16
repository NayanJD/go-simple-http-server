## Playing with HTTP Server in Go

This repository is a playground for learning web services in Go.

## Test Results

### DigitalOcean Droplets

#### Setup:

1. Spin up droplets:
```zsh
source .env # ensure the variables are properly setup
make tf-init
make tf-apply
```

2. Set `GO_SERVER_IP`, `TEST_SERVER_IP` and `MONITORING_SERVER_IP` in .env from the output of step 1. Run:
```zsh
source .env
```

3. Start tmuxinator session:
```zsh
envsubst < .tmuxinator.yml.tmpl > .tmuxinator.yml
tmuxinator
```

4. Run go server in go-server window and setup node-exporter:

```zsh
cd /root/simplehttp
go run src/cmd/server.go
```

Setup node-exporter in another pane:

```zsh
n compose -f monitoring/node-exporter-compose.yml up -d
```

5. Setup prometheus in monitoring-server window:
```zsh
cd simplehttp
source .env
envsubst < monitoring/prometheus.yml > prometheus.yml
n compose -f monitoring/docker-compose.yml up -d
```

6. Run bench command in test-server window:

```zsh
source .env
wrk -t2 -c1000 -d30s -R1000000 http://$GO_SERVER_IP:9000/hello
```


#### Result

With basic droplet size `s-2vcpu-4gb`, request rate achieved ~13k req/s.

With compute droplet size `c-2`, request rate achieved ~13k req/s.

With compute droplet size `c-4`, request rate achieved ~39k req/s.

With compute droplet size `c-4` & logging disabled, request rate achieved ~65k req/s.
