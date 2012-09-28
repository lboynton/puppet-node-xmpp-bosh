class bosh {
    include nodejs
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
    }
}