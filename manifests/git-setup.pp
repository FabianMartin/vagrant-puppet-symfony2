class symfony2::git-setup {
  package { 'git':
    ensure => installed,
    require => Exec["apt-get-update"],
  }
}