# Tester extension for Chassis
class tester::config (
  $test_config = {},
  $ensure = present,
) {
  # If test DB configuration was provided, pull those values out.
  $test_database = $test_config[name] ? {
    /.*/ => $test_config[name],
    default => undef,
  }
  $test_database_user = $test_config[user] ? {
    /.*/ => $test_config[user],
    default => undef,
  }
  $test_database_password = $test_config[password] ? {
    /.*/ => $test_config[password],
    default => 'password',
  }
  $test_database_host = $test_config[host] ? {
    /.*/ => $test_config[host],
    default => 'localhost',
  }
  $test_database_prefix = $test_config[prefix] ? {
    /.*/ => $test_config[prefix],
    default => 'test_',
  }

  file { '/vagrant/extensions/tester/wpdevel/wp-tests-config.php':
    ensure  => $ensure,
    content => template('tester/wp-tests-config.php.erb')
  }

  file { '/etc/profile.d/tester-env.sh':
    ensure  => $ensure,
    content => template('tester/tester-env.sh.erb')
  }

  # Determine whether a DB configuration file should exist.
  if ( absent == $ensure ) {
    $db_config_file = absent
  } elsif ( empty( $test_database ) and empty( $test_database_user ) ) {
    $db_config_file = absent
  } else {
    $db_config_file = present
  }

  file { '/vagrant/local-config-tester.php':
    ensure  => $db_config_file,
    content => template('tester/local-config-tester.php.erb')
  }

  if ( present == $ensure ) {
    exec { 'load_tester_envs':
      path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
      command   => "bash -c 'source /etc/profile.d/tester-env.sh'",
      subscribe => File['/etc/profile.d/tester-env.sh']
    }
  }
}
