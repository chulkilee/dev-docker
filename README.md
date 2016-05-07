# dev-docker

Configuration for local development using docker.

## Components

- DNS server: [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) [![](https://imagelayers.io/badge/andyshinn/dnsmasq:latest.svg)](https://imagelayers.io/?images=andyshinn/dnsmasq:latest 'Get your own badge on imagelayers.io')
- HTTP reverse proxy: [traefik](https://github.com/containous/traefik) [![](https://imagelayers.io/badge/containous/traefik:latest.svg)](https://imagelayers.io/?images=containous/traefik:latest 'Get your own badge on imagelayers.io')
- Service discovery: [consul](https://github.com/hashicorp/consul) [![](https://imagelayers.io/badge/consul:latest.svg)](https://imagelayers.io/?images=consul:latest 'Get your own badge on imagelayers.io') and [registrator](https://github.com/gliderlabs/registrator) [![](https://imagelayers.io/badge/gliderlabs/registrator:latest.svg)](https://imagelayers.io/?images=gliderlabs/registrator:latest 'Get your own badge on imagelayers.io')
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

- traefik dashboard: https:///traefik-dashboard.test
- consul dashboard: https://consul-http.test
- mailhog ui: https://mailhog-ui.test

## Features

### Service discovery inside docker containers

All docker containers will be detected and added to consul by registrator.

```sh
# use docker link
docker run --rm -it --link smtp alpine:3.3 ping -c 1 smtp

# use consul
docker run --rm -it alpine:3.3 ping -c 1 smtp.service.consul
```

### HTTP reverse proxy

All consul services will be registered to HTTP reverse proxy at `[servicename](-[port]).test` unless it has service tag `traefik.enabled=false`.

```sh
docker run --rm -e SERVICE_NAME=nginx -e SERVICE_443_IGNORE=true nginx

curl -k https://consul-http.test/v1/catalog/service/nginx-80
```

## Recommended convention

When you add a project (e.g. Rails application with database), consider this convention:

- project name
  - a project must have own unique name, such as `blog`
  - name should not include dash or underscore
- `docker-compose.yml`
  - a project must have `docker-compose.yml` file
  - it should declare all internal dependencies, such as database
  - it should mount `.` for local development

Here are example configuration files for Rails application.

**Dockerfile**

```dockerfile
FROM ruby:2.3.1

WORKDIR /usr/src/app
EXPOSE 3000
RUN gem install bundler
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*
ENV RAILS_SERVE_STATIC_FILES=1 RAILS_LOG_TO_STDOUT=1

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install --jobs 8 --retry 5

COPY . /usr/src/app/
RUN RAILS_ENV=production bin/rake assets:precompile

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
```

**docker-compose.yml**

```yaml
web:
  container_name: blog_web
  build: .
  links:
    - postgres
  external_links:
    - smtp
  environment:
    - VIRTUAL_HOST=blog.test
  volumes:
    - .:/usr/src/app

postgres:
  container_name: blog_postgres
  image: postgres:latest
```

## See also

- [codekitchen/dinghy](https://github.com/codekitchen/dinghy)
- [Development with Docker Compose](http://howtocookmicroservices.com/docker-compose/)
- [Docker, Rails, & Docker Compose together in your development workflow](http://blog.carbonfive.com/2015/03/17/docker-rails-docker-compose-together-in-your-development-workflow/)

## License

[MIT License](https://opensource.org/licenses/MIT)
