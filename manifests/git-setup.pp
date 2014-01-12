# Class: symfony2::git-setup
#
#
class symfony2::git-setup {
  package { 'git':
    ensure => installed,
    require => Exec["apt_update"],
  }
}