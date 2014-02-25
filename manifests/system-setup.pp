class symfony2::system-setup {
  group { "www-data":
    ensure => "present",
    gid => 33,
    system => true
  }

  user { "www-data":
    ensure => "present",
    gid => 33,
    home => "/var/www",
    shell => "/bin/bash",
    system => true,
    uid => 33,
    require => Group["www-data"],
  }

  exec { "www-data-password":
    command => 'echo "www-data:vagrant" | chpasswd',
    require => User["www-data"],
  }

  file { "/var/www/":
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 0644,
    require => User["www-data"],
  }

  file { "/var/www/.ssh/":
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 0700,
    require => [User["www-data"], File["/var/www/"]],
  }

  file { "/var/www/.ssh/authorized_keys":
    ensure => file,
    owner => "www-data",
    group => "www-data",
    mode => 0644,
    source => '/home/vagrant/.ssh/authorized_keys',
    require => [User["www-data"], File["/var/www/"]],
  }

  file { '/var/www/.bash_login':
    owner => "www-data",
    group => "www-data",
    mode => 0755,
    ensure => file,
    source => 'puppet:///modules/symfony2/.bash_login',
    require => [User["www-data"], File["/var/www/"]],
  }

  file { "/etc/localtime":
      ensure => "/usr/share/zoneinfo/Europe/Berlin"
  }

  file { "/etc/timezone":
    content => "Europe/Berlin\n",
  }
}