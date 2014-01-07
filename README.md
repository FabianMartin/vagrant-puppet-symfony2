# vagrant-puppet-symfony2

Puppet module to install all necessary packages for symfony2 and vagrant

## Features

* nginx
* php5
* mysql
* composer
* capifony
* less
* git
* memcache

## Configuration

	class {'symfony2':
	  mapping_type    => "system",
	  setup_nginx     => false,
	  setup_php       => false,
	  setup_composer  => false,
	  setup_capifony  => false,
	  setup_less      => false,
	  setup_git       => false,
	  setup_mysql     => false,
	  setup_memcache  => false
	}

### mapping_type

**type:** enum (system, system_link, share)<br/>
**default:** system

**system:** Add a synchronized folder in the vagrant configuration to use this option

	config.vm.synced_folder ".", "/var/www", type: "nfs", owner: "www-data", group: "www-data"

**system_link:** Same as system, in addition it will also create a number of symbolic links within the VM (app/logs, app/cache, vendor, web/bundles)

**share:** Creates a file share for /var/www within the VM. During the provisioning, all files are copied from /vagrant to /var/www. All changed files will be automatically copied from /var/www to /vagrant.

### Other options

All other options are self-explanatory

## Dependencies

* [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/git](https://forge.puppetlabs.com/puppetlabs/git)
* [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/mysql)

### As puppet module

    puppet module install puppetlabs/apt
    puppet module install puppetlabs/stdlib
    puppet module install puppetlabs/git
    puppet module install puppetlabs/mysql

### As submodules

    git submodule add git://github.com/puppetlabs/puppetlabs-apt.git app/vagrant/puppet/modules/apt
    git submodule add git://github.com/puppetlabs/puppetlabs-stdlib.git app/vagrant/puppet/modules/puppetlabs-stdlib
    git submodule add git://github.com/puppetlabs/puppetlabs-git.git app/vagrant/puppet/modules/git
    git submodule add git://github.com/puppetlabs/puppetlabs-mysql.git app/vagrant/puppet/modules/mysql

# Based on

* [https://github.com/jou/vagrant-symfony2-example](https://github.com/jou/vagrant-symfony2-example)
* [https://github.com/irmantas/symfony2-vagrant/](https://github.com/irmantas/symfony2-vagrant/)