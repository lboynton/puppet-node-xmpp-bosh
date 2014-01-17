#!/usr/bin/env sh
exec /usr/bin/bosh-server "$@" >> /var/log/bosh/bosh.log 2>> /var/log/bosh/bosh.err & echo $! > /var/run/bosh/bosh.pid