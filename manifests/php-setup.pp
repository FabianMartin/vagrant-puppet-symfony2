class symfony2::php-setup {
  $php = ["php5-dev", "php5-gd", "php5-curl", "php5-mcrypt", "php5-xdebug", "php5-sqlite", "php5-mysql", "php5-memcache", "php5-intl", "php5-ldap", "php5-imap", "php5-imagick"]

  apt::ppa { 'ppa:ondrej/php5': }

  package { ["php5-fpm", "php5-cli"]:
    notify => Service['php5-fpm'],
    ensure => latest,
    require => Apt::Ppa["ppa:ondrej/php5"],
  }

  package { $php:
    notify => Service['php5-fpm'],
    ensure => latest,
    require => [Apt::Ppa["ppa:ondrej/php5"], Package["php5-fpm", "php5-cli"]]
  }

  package { "apache2.2-bin":
    notify => Service['nginx'],
    ensure => purged,
    require => Package[$php],
  }

  package { "phpmyadmin":
    ensure => present,
    require => Package[$php],
  }

  file { "/etc/php5/conf.d/":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 644,
    require => Package[$php],
  }

  file { '/etc/php5/conf.d/timezone.ini':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => 'puppet:///modules/symfony2/php/conf.d/timezone.ini',
    require => Package[$php],
  }

  file { ["/etc/php5/cli/conf.d/99-timezone.ini", "/etc/php5/fpm/conf.d/99-timezone.ini"]:
    ensure => link,
    target => "/etc/php5/conf.d/timezone.ini",
    require => Package[$php],
    notify => Service["php5-fpm"],
  }

  file { '/etc/php5/conf.d/xdebug.ini':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => 'puppet:///modules/symfony2/php/conf.d/xdebug.ini',
    require => Package[$php],
  }

  file { ["/etc/php5/cli/conf.d/99-xdebug.ini", "/etc/php5/fpm/conf.d/99-xdebug.ini"]:
    ensure => link,
    target => "/etc/php5/conf.d/xdebug.ini",
    require => Package[$php],
    notify => Service["php5-fpm"],
  }

  file { '/etc/php5/fpm/pool.d/www.conf':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => 'puppet:///modules/symfony2/php/pool.d/www.conf',
    require => Package[$php],
    notify => Service["php5-fpm"],
  }

  service { "php5-fpm":
    ensure => running,
    require => Package["php5-fpm"],
  }
}