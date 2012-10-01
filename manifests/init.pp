class bosh {
    include nodejs
    $deps = ['expat-devel', 'zlib-devel']
    package {$deps:
        ensure => present,
    }
    # Tell npm to install packages as root user instead of dropping to the
    # nobody user due to error with node-gyp. This will hopefully be fixed
    # when a newer version of node-gyp is used.
    exec { 'sudo /usr/bin/npm config set unsafe-perm true':
		alias => 'npm-unsafe-perm',
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
}