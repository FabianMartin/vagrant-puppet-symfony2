class symfony2::nginx-setup {
  apt::ppa { 'ppa:nginx/stable': }

  package { "nginx":
    ensure => "latest",
    require => Apt::Ppa["ppa:nginx/stable"]
  }

  service { "nginx":
    enable => true,
    ensure => running,
    require => Package["nginx"],
    subscribe => File['/etc/nginx/sites-enabled/default']
  }

  file { '/etc/nginx/sites-available/default':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => 'puppet:///modules/symfony2/nginx/default-vhost',
    require => Package["nginx"],
  }

  file { "/etc/nginx/sites-enabled/default":
    ensure => link,
    target => "/etc/nginx/sites-available/default",
    require => Package["nginx"],
    notify => Service["nginx"],
  }
}