class symfony2::nginx-setup {
  apt::ppa { 'ppa:nginx/stable': }

  package { "nginx-full":
    ensure => "latest",
    require => [Apt::Ppa["ppa:nginx/stable"], User["www-data"]]
  }

  service { "nginx":
    enable => true,
    ensure => running,
    require => Package["nginx-full"],
  }

  file { '/etc/nginx/sites-available/default':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => 'puppet:///modules/symfony2/nginx/default-vhost',
    require => Package["nginx-full"],
    notify => Service["nginx"],
  }

  file { "/etc/nginx/sites-enabled/default":
    ensure => link,
    target => "/etc/nginx/sites-available/default",
    require => Package["nginx-full"],
    notify => Service["nginx"],
  }
}