class symfony2::composer-setup {
  package { ["curl"]:
    ensure => "installed",
    require => Exec["apt-get-update"],
  }

  exec { 'install composer php dependency management':
      command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
      creates => '/usr/bin/composer',
      require => [Package['php5-cli'], Package['curl']],
  }

  exec { 'composer self update':
      command => 'composer self-update',
      require => [Package['php5-cli'], Package['curl'], Exec['install composer php dependency management']],
  }

  # Composer runs as root, so if it creates cache entries, the web process can't change them
  # exec { "fix-cache-owner":
  #   command => "/bin/chown -R vagrant:vagrant /vagrant/app/cache/*",
  #   require => composer::exec['composer-install'],
  # }
}