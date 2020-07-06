# Tester extension for Chassis
class tester::config (
	$test_database = undef,
	$test_database_user = undef,
	$test_database_password = undef,
	$test_database_host = undef,
	$test_database_prefix = 'test_',
) {
  if ( ! empty( $::config[disabled_extensions] ) and 'chassis/tester' in $::config[disabled_extensions] ) {
    $file = absent
  } else {
    $file = present
  }

  file { '/vagrant/extensions/tester/wpdevel/wp-tests-config.php':
    ensure  => $file,
    content => template('tester/wp-tests-config.php.erb')
  }

  file { '/etc/profile.d/tester-env.sh':
    ensure  => $file,
    content => template('tester/tester-env.sh.erb')
  }

  if ( $file == absent or $test_database ) {
    file { '/vagrant/local-config-tester.php':
      ensure  => $file,
      content => template('tester/local-config-tester.php.erb')
    }
  }

  if ( present == $file ) {
    exec { 'load_tester_envs':
      path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
      command   => "bash -c 'source /etc/profile.d/tester-env.sh'",
      subscribe => File['/etc/profile.d/tester-env.sh']
    }
  }
}
