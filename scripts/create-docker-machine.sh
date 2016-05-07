#!/bin/bash -eux
exec docker-machine create \
  --driver virtualbox \
  --virtualbox-cpu-count "2" \
  --virtualbox-memory "4096" \
  --virtualbox-disk-size "32000" \
  --virtualbox-host-dns-resolver \
  default
