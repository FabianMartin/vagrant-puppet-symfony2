# vagrant-puppet-symfony2

Puppet module to install all necessary packages for symfony2 and vagrant

## Install

Install as git submodule

	git submodule add git://github.com/FabianMartin/vagrant-puppet-symfony2.git app/vagrant/puppet/modules/symfony2

## Features

* nginx
* php5
* mysql
* composer
* capifony
* less
* git
* memcache
* samba
* lsyncd

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
	  setup_memcache  => false,
	  setup_lsyncd	  => false
	}

### mapping_type

**type:** enum (system, system_link, share)<br/>
**default:** system

**system:** Add a synchronized folder in the vagrant configuration to use this option

	config.vm.synced_folder ".", "/var/www/project", type: "nfs", owner: "www-data", group: "www-data"

**system_link:** Same as system, in addition it will also create a number of symbolic links within the VM (app/logs, app/cache, vendor, web/bundles)

**share:** Creates a file share for /var/www within the VM. During the provisioning, all files are copied from /vagrant to /var/www/project. All changed files will be automatically copied from /var/www/project to /vagrant (if setup_lsyncd is true).

### Other options

All other options are self-explanatory

## Dependencies

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql)

### As puppet module

    puppet module install puppetlabs/stdlib
    puppet module install puppetlabs/mysql

### As submodules

    git submodule add git://github.com/puppetlabs/puppetlabs-stdlib.git app/vagrant/puppet/modules/puppetlabs-stdlib
    git submodule add git://github.com/puppetlabs/puppetlabs-mysql.git app/vagrant/puppet/modules/mysql

# Based on

* [https://github.com/jou/vagrant-symfony2-example](https://github.com/jou/vagrant-symfony2-example)
* [https://github.com/irmantas/symfony2-vagrant/](https://github.com/irmantas/symfony2-vagrant/)