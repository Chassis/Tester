# Tester extension for Chassis
class tester (
	$config,
	$install_path = '/usr/local/src/phpunit',
) {

	if ( !empty($config[disabled_extensions]) and 'chassis/tester' in $config[
		disabled_extensions] ) {
		$tester = absent
	} else {
		$tester = present
	}

	if ( present == $tester ) {
		# Create the install path
		file { $install_path:
			ensure => directory,
		}

		if ( $config[php] < 5.6 ) {
			$phpunit_repo_url = 'https://phar.phpunit.de/phpunit-4.8.phar'
		} else {
			$phpunit_repo_url = 'https://phar.phpunit.de/phpunit-5.7.phar'
		}

		# Download phpunit
		exec { 'phpunit download':
			command => "/usr/bin/curl -o ${install_path}/phpunit.phar -L ${
				phpunit_repo_url}",
			require => [ Package[ 'curl' ], File[ $install_path ] ],
			creates => "${install_path}/phpunit.phar",
		}

		# Ensure we can run phpunit
		file { "${install_path}/phpunit.phar":
			ensure  => present,
			mode    => 'a+x',
			require => Exec[ 'phpunit download' ]
		}

		# Symlink it across
		file { '/usr/bin/phpunit':
			ensure  => link,
			target  => "${install_path}/phpunit.phar",
			require => File[ "${install_path}/phpunit.phar" ],
		}

		if ( $config[tester_db] ) {
			mysql::db { $config[tester_db][name]:
				user     => $config[tester_db][user],
				password => $config[tester_db][password],
				host     => localhost,
				grant    => ['all']
		}

		} else {
			file { $install_path:
				ensure => $tester,
				force  => true
			}
			file { '/usr/bin/phpunit':
				ensure => absent
			}
		}

		class { 'tester::config': }
	}
}
