# Class: symfony2::less-setup
#
#
class symfony2::less-setup {
  apt::ppa{'ppa:chris-lea/node.js': }

  package { "nodejs":
    ensure => "installed",
    require => Apt::Ppa["ppa:chris-lea/node.js"],
  }

  exec { 'install less using npm':
    command => 'npm install -g less',
    require => Package["nodejs"],
  }
}