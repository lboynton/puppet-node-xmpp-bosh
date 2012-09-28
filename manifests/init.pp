class bosh {
    include nodejs
    $deps = ['expat-devel', 'zlib-devel']
    package {$deps:
        ensure => present,
    }
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
            Package[$deps],
        ]
    }
}