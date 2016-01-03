class tester (
	$install_path = "/usr/local/src/phpunit",
	$install_old_path = "/usr/local/src/phpunitold",
) {
	# Create the install paths
	file { $install_path:
		ensure => directory,
	}

	# Download phpunit
	exec { "phpunit download":
		command => "/usr/bin/curl -o $install_path/phpunit.phar -L https://phar.phpunit.de/phpunit.phar",
		require => [ Package[ 'curl' ], File[ $install_path ] ],
		creates => "$install_path/phpunit.phar",
	}

	# Ensure we can run phpunit
	file { "$install_path/phpunit.phar":
		ensure => "present",
		mode => "a+x",
		require => Exec[ 'phpunit download' ]
	}

	# Symlink it across
	file { '/usr/bin/phpunit':
		ensure => link,
		target => "$install_path/phpunit.phar",
		require => File[ "$install_path/phpunit.phar" ],
	}

	# Create the old install path
	file { $install_old_path:
		ensure => directory,
	}

	# Download old phpunit
	exec { "phpunitold download":
		command => "/usr/bin/curl -o $install_old_path/phpunit-old.phar -L https://phar.phpunit.de/phpunit-old.phar",
		require => [ Package[ 'curl' ], File[ $install_old_path ] ],
		creates => "$install_old_path/phpunit-old.phar",
	}

	# Ensure we can run old phpunit
	file { "$install_old_path/phpunit-old.phar":
		ensure => "present",
		mode => "a+x",
		require => Exec[ 'phpunitold download' ]
	}

	# Symlink it across
	file { '/usr/bin/phpunitold':
		ensure => link,
		target => "$install_old_path/phpunit-old.phar",
		require => File[ "$install_old_path/phpunit-old.phar" ],
	}
}
