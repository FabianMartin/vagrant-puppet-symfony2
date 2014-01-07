class symfony2::mapping::share {
  package { ["samba", "lsyncd"]:
    ensure => installed,
    notify => Service['smbd', "lsyncd"],
    require => Package["nginx"]
  }

  file { '/etc/samba/smb.conf':
    owner  => root,
    group  => root,
    ensure => file,
    source => 'puppet:///modules/symfony2/samba/smb.conf',
    require => Package["samba"],
    notify => Service['smbd'],
  }

  file { "/var/www/":
    ensure => directory,
    recurse => true,
    purge => true,
    force => true,
    owner => "www-data",
    group => "www-data",
    mode => 0644, 
    source => "/vagrant",
    require => [Package["nginx"], Exec["stop-lsyncd"]],
  }

  exec { "stop-lsyncd":
    command => "/etc/init.d/lsyncd stop",
    onlyif => "test -f /etc/init.d/lsyncd",
  }

  service{"smbd":
    ensure => running,
    require => Package["samba"],
  }

  service{"lsyncd":
    ensure => running,
    require => [Package["lsyncd"], File["/var/www"]]
  }
}