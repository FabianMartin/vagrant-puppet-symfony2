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

  file { "/etc/localtime":
      ensure => "/usr/share/zoneinfo/Europe/Berlin"
  }

  file { "/etc/timezone":
    content => "Europe/Berlin\n",
  }
}