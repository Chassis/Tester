class tester (
	$install_path = "/usr/local/src/phpunit",
) {
	# Create the install path
	file { $install_path:
		ensure => directory,
	}

	if versioncmp( "$tester_config[php]", '7.0' ) >= 0 {
		$phpunit_package_name = "phpunit.phar"
		$phpunit_repo_url     = "https://phar.phpunit.de/phpunit.phar"
	} else {
		$phpunit_package_name = "phpunit-old.phar"
		$phpunit_repo_url     = "https://phar.phpunit.de/phpunit-old.phar"
	}

	# Download phpunit
	exec { "phpunit download":
		command => "/usr/bin/curl -o $install_path/$phpunit_package_name -L $phpunit_repo_url",
		require => [ Package[ 'curl' ], File[ $install_path ] ],
		creates => "$install_path/$phpunit_package_name",
	}

	# Ensure we can run phpunit
	file { "$install_path/$phpunit_package_name":
		ensure => "present",
		mode => "a+x",
		require => Exec[ 'phpunit download' ]
	}

	# Symlink it across
	file { '/usr/bin/phpunit':
		ensure => link,
		target => "$install_path/$phpunit_package_name",
		require => File[ "$install_path/$phpunit_package_name" ],
	}
}
