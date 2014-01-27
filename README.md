# puppet-node-xmpp-bosh

Puppet module for installing [node-xmpp-bosh](https://github.com/dhruvbird/node-xmpp-bosh). Tested on CentOS 6.

Usage:

```puppet
include bosh
```

Or to configure:

```puppet
class { 'bosh':
    logging                 => 'INFO',
    route_filter            => '/.*/',
    system_info_password    => 'mypassword'
}
```