#!/bin/bash -eux
if [ -z "${DOCKER_HOST:-}" ]; then
  docker_host_ip=127.0.0.1
else
  docker_host_ip=$(echo $DOCKER_HOST | awk -F '//|:' '{print $3}')
fi

sudo rm -f /etc/resolver/test /etc/resolver/consul
sudo killall -HUP mDNSResponder

echo "nameserver $docker_host_ip" | sudo tee /etc/resolver/test /etc/resolver/consul
sudo killall -HUP mDNSResponder
