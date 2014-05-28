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
git clone https://github.com/Chassis/Tester.git tester

# Reprovision
cd ..
vagrant provision
```

You're now ready to run any WordPress unit tests locally!