## Playing with HTTP Server in Go

This repository is a playground for learning web services in Go.

## Test Results

#### DigitalOcean Droplets

Test command:

```shell
wrk -t2 -c1000 -d30s -R1000000 http://10.10.10.2:9000/hello
```

With basic droplet size `s-2vcpu-4gb`, request rate achieved ~13k req/s.

With compute droplet size `c-2`, request rate achieved ~13k req/s.

With compute droplet size `c-4`, request rate achieved ~39k req/s.
