# Tester extension for Chassis
class tester::config {
  if ( ! empty( $config[disabled_extensions] ) and 'chassis/tester' in $config[disabled_extensions] ) {
    $file = absent
  } else {
    $file = present
  }

  file { '/vagrant/extensions/tester/wpdevel/wp-tests-config.php':
    content => template('tester/wp-tests-config.php.erb'),
    ensure  => $file
  }

  file { '/etc/profile.d/tester-env.sh':
    content => template('tester/tester-env.sh.erb'),
    ensure  => $file
  }
}
