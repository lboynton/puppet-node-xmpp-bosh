class bosh(
    $logging                = 'FATAL',  # default log level. Valid options are ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF
    $route_filter           = '/.*/',   # default allows all routes
    $system_info_password   = ''        # default of empty password disables sysinfo area
) {
    include epel
    include nodejs

    Class['epel'] -> Class['nodejs']

    $deps = ['expat-devel', 'zlib-devel', 'make']

    package { $deps:
        ensure => present,
    }
    package { 'node-xmpp-bosh':
        ensure   => present,
        provider => 'npm',
        require  => [
            Class['nodejs'],
            Package[$deps],
        ],
    }
    user { 'bosh':
        ensure => present,
        system => true,
    }
    file { '/etc/bosh.js.conf':
        ensure  => present,
        content => template('bosh/bosh.conf.js.erb'),
        before  => Service['bosh'],
    }
    file { '/etc/init.d/bosh':
        ensure => present,
        source => 'puppet:///modules/bosh/bosh-init.sh',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service['bosh'],
    }
    file { '/usr/local/bin/start-bosh':
        ensure => present,
        source => 'puppet:///modules/bosh/start-bosh.sh',
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