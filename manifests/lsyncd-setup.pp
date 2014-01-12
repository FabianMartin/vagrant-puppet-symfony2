class symfony2::lsyncd-setup {
  package { "lsyncd":
    ensure => "installed",
    notify => Service["lsyncd"],
    require => User["www-data"],
  }

  service{"lsyncd":
    ensure => running,
    require => [Package["lsyncd"], File["/var/www/project"]],
    subscribe => File['/var/www/project/'],
  }

  file { '/etc/lsyncd':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 644,
    require => Package["lsyncd"],
  }

  file { '/etc/lsyncd/lsyncd.conf.lua':
    owner  => root,
    group  => root,
    ensure => file,
    source => 'puppet:///modules/symfony2/lsyncd/lsyncd.conf.lua',
    require => Package["lsyncd"],
    notify => Service['lsyncd'],
  }
}