# Tester extension for Chassis
Run WP plugin unit tests without changing your Chassis setup! The Tester
extension automatically sets up your Chassis instance to be able to run plugin
unit tests.

## Activation
Ensure you have a Chassis instance set up locally already.

```
# In your Chassis dir:
cd extensions

# Grab the extension
git clone --recursive https://github.com/Chassis/Tester.git tester

# Reprovision
cd ..
vagrant provision
```

# Usage
```
vagrant ssh
cd /vagrant/content/{plugins|themes}/yourdirectory
phpunit
```

# Custom Database

You can optionally provide a custom database for the tests to use in one of your `.yaml` files: e.g.
```
tester_db:
    name: customtests
    user: wordpress
    password: vagrantpassword
```

You're now ready to run any WordPress unit tests locally!
