class bosh {
    include nodejs
    package {'expat-devel':
        ensure => present,
    }
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
            Package['expat-devel'],
        ]
    }
}