class symfony2::less-setup {
  exec { 'ppa:chris-lea/node.js':
    command => '/usr/bin/add-apt-repository ppa:chris-lea/node.js',
    before => Exec['apt-ppa-update'],
    require => Package["python-software-properties"],
  }

  package { "nodejs":
    ensure => "installed",
    require => [Exec["ppa:chris-lea/node.js"], Exec['apt-ppa-update']]
  }

  exec { 'install less using npm':
    command => 'npm install -g less',
    require => Package["nodejs"],
  }
}