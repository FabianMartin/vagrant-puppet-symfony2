class symfony2::mapping::share {
  package { ["samba"]:
    ensure => installed,
    notify => Service['smbd'],
    require => User["www-data"],
  }

  file { "/var/www/project/":
    ensure => directory,
    recurse => true,
    purge => true,
    force => true,
    owner => "www-data",
    group => "www-data",
    mode => 0664, 
    source => "/vagrant",
    ignore => ["/app", "/vendor", ".idea", ".git"],
    require => [User["www-data"], Exec["stop-lsyncd"], File["/var/www/"]],
  }

  file { "/var/www/project/app":
    ensure => directory,
    recurse => true,
    purge => true,
    force => true,
    owner => "www-data",
    group => "www-data",
    mode => 0664, 
    source => "/vagrant/app",
    ignore => ["/cache", "/logs", ".git"],
    require => [User["www-data"], Exec["stop-lsyncd"], File["/var/www/project/"]],
  }

  file { ["/var/www/project/vendor", "/var/www/project/app/logs", "/var/www/project/app/cache"]:
    ensure => directory,
    force => true,
    owner => "www-data",
    group => "www-data",
    mode => 0664, 
    require => [User["www-data"], Exec["stop-lsyncd"], File["/var/www/project/"]],
  }

  mount { ["/var/www/project/app/logs", "/var/www/project/app/cache"]:
    device => "tmpfs",
    atboot => true,
    options => "size=256M,rw",
    ensure => mounted,
    fstype => "tmpfs",
    require => File["/var/www/project/app/logs", "/var/www/project/app/cache"],
    remounts => false,
  }

  file { '/etc/samba/smb.conf':
    owner  => root,
    group  => root,
    ensure => file,
    source => 'puppet:///modules/symfony2/samba/smb.conf',
    require => Package["samba"],
    notify => Service['smbd'],
  }

  service{"smbd":
    ensure => running,
    require => Package["samba"],
  }

  exec { "stop-lsyncd":
    command => "/etc/init.d/lsyncd stop",
    onlyif => "test -f /etc/init.d/lsyncd",
  }
}