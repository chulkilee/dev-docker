# dev-docker

Configuration for local development using docker.

## Components

- DNS server: [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) [![](https://imagelayers.io/badge/andyshinn/dnsmasq:latest.svg)](https://imagelayers.io/?images=andyshinn/dnsmasq:latest 'Get your own badge on imagelayers.io')
- HTTP reverse proxy: [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) [![](https://imagelayers.io/badge/jwilder/nginx-proxy:latest.svg)](https://imagelayers.io/?images=jwilder/nginx-proxy:latest 'Get your own badge on imagelayers.io')
- Service discovery: [legacy docker container link](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/)
- SMTP server and UI: [mailhog](https://github.com/mailhog/MailHog) [![](https://imagelayers.io/badge/mailhog/mailhog:latest.svg)](https://imagelayers.io/?images=mailhog/mailhog:latest 'Get your own badge on imagelayers.io')

## Setting up

### Install host dependencies

- docker-compose
- docker
  - docker-machine with [Virtualbox](https://www.virtualbox.org/)
  - Docker for Mac

For docker-compose and docker-machine, you can install [Docker Toolbox](https://www.docker.com/products/docker-toolbox) or from homebrew (`brew install docker-machine docker-compose`)

### Run docker

**docker-machine**

Run Kitematic.app or Docker Quickstart Terminal.app to create default docker machine. Or run [scripts/create-docker-machine.sh](scripts/create-docker-machine.sh).

Then run `eval $(docker-machine env default)` to set your environment.

**Docker for Mac**

Run the Docker.app

### Configure DNS resolver on host

Run [scripts/add-resolver.sh](scripts/add-resolver.sh) to let your host environment use DNS server running in docker.

### Run docker-compose

```sh
docker-compose up
```

Check out default services:

- mailhog ui: https://mailhog-ui.test

## Adding applications

### Service discovery inside docker containers

```sh
docker run --rm -it --link smtp alpine:3.3 ping -c 1 smtp
```

### HTTP reverse proxy

All containers having `VIRTUAL_HOST` environment variable set will be registered to HTTP reverse proxy at `[VIRTUAL_HOST].test`.

```sh
docker run --rm -e VIRTUAL_HOST=nginx.test nginx
```

## See also

- [codekitchen/dinghy](https://github.com/codekitchen/dinghy)
- [Development with Docker Compose](http://howtocookmicroservices.com/docker-compose/)

## License

[MIT License](https://opensource.org/licenses/MIT)
