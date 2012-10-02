class bosh {
    include nodejs
    $deps = ['expat-devel', 'zlib-devel']
    package {$deps:
        ensure => present,
    }
    # Tell npm to install packages as root user instead of dropping to the
    # nobody user due to error with node-gyp. This will hopefully be fixed
    # when a newer version of node-gyp is used.
    exec { '/usr/bin/npm config set unsafe-perm true':
        alias     => 'npm-unsafe-perm',
        logoutput => true,
        require   => Package['npm'],
    }
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
            Package[$deps],
            Exec['npm-unsafe-perm'],
        ]
    }
    user { 'bosh':
        ensure => present,
        system => true,
    }
    file { '/etc/bosh.js.conf':
        ensure => present,
        source => 'puppet:///files/node-xmpp-bosh/bosh.js',
        before => Service['bosh'],
    }
    file { '/etc/init.d/bosh':
        ensure => present,
        source => 'puppet:///files/node-xmpp-bosh/bosh-init',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service['bosh'],
    }
    file { '/usr/local/bin/start-bosh':
        ensure => present,
        source => 'puppet:///files/node-xmpp-bosh/start-bosh',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service['bosh'],
    }
    file { '/var/log/bosh':
        ensure  => directory,
        owner   => 'bosh',
        group   => 'bosh',
        before  => Service['bosh'],
        require => User['bosh'],
    }
    file { '/var/run/bosh':
        ensure  => directory,
        owner   => 'bosh',
        group   => 'bosh',
        before  => Service['bosh'],
        require => User['bosh'],
    }
    service { 'bosh':
        ensure   => running,
        enable   => true,
        require  => Package['node-xmpp-bosh'],
    }
}