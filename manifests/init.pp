class bosh {
    include nodejs
    $deps = ['expat-devel', 'zlib-devel']
    package {$deps:
        ensure => present,
    }
    # workaround for error by installing dependency globally
    package { 'node-gyp':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
        ]
    }
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
            Package[$deps],
            Package['node-gyp'],
        ]
    }
}