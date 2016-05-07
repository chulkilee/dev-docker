#!/bin/sh
DOCKER_HOST=$1

if [ -z "${DOCKER_HOST}" ]; then
  docker_host_ip=127.0.0.1
else
  docker_host_ip=$(echo $DOCKER_HOST | awk -F '//|:' '{print $3}')
fi

consul_ip=$(ping -c 1 consul | head -1 | awk '{print $3}' | grep -o '[0-9.]*')

exec dnsmasq -k \
  --log-queries --log-facility=- \
  --address=/test/$docker_host_ip \
  --server=/consul/$consul_ip#8600
