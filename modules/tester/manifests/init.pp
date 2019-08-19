# Tester extension for Chassis
class tester (
	$config,
) {

	if ( !empty($config[disabled_extensions]) and 'chassis/tester' in $config[
		disabled_extensions] ) {
		$tester = absent
	} else {
		$tester = present
	}

	if ( present == $tester ) {

		if ( $config[tester_db] ) {
			mysql::db { $config[tester_db][name]:
				user     => $config[tester_db][user],
				password => $config[tester_db][password],
				host     => localhost,
				grant    => ['all']
			}
		}

		class { 'tester::config': }
	} else {
		exec { 'unset env variables':
			command  => 'unset WP_DEVELOP_DIR; unset WP_TESTS_DIR;',
			path     => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
			provider => 'shell'
		}
	}
}
