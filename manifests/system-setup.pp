class symfony2::system-setup {
  package { 'libshadow':
    ensure   => 'installed',
    provider => 'gem',
  }

  group { "www-data":
    ensure => "present",
    gid => 33,
    system => true
  }

  user { "www-data":
    ensure => "present",
    gid => 33,
    home => "/var/www",
    shell => "/bin/bash",
    system => true,
    uid => 33,
    password => '$6$aqzOtgCM$OxgoMP4JoqMJ1U1F3MZPo2iBefDRnRCXSfgIM36E5cfMNcE7GcNtH1P/tTC2QY3sX3BxxJ7r/9ciScIVTa55l0',
    require => [Group["www-data"], Package["libshadow"]],
  }

  file { "/var/www/":
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 0644,
    require => User["www-data"],
  }

  file { "/etc/localtime":
      ensure => "/usr/share/zoneinfo/Europe/Berlin"
  }

  file { "/etc/timezone":
    content => "Europe/Berlin\n",
  }
}