# Tester extension for Chassis
class tester::config {
  file { '/vagrant/extensions/tester/wpdevel/wp-tests-config.php':
    content => template('tester/wp-tests-config.php.erb'),
  }

  file { '/etc/profile.d/tester-env.sh':
    content => template('tester/tester-env.sh.erb'),
  }
}
