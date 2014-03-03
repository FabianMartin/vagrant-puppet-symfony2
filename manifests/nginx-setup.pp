class symfony2::nginx-setup {
  exec { 'ppa:nginx/stable':
    command => '/usr/bin/add-apt-repository ppa:nginx/stable',
    before => Exec['apt-ppa-update'],
    require => Package["python-software-properties"],
  }

  package { "nginx-full":
    ensure => "latest",
    require => [Exec["ppa:nginx/stable"], Exec['apt-ppa-update'], User["www-data"]]
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