class symfony2::capifony-setup {
  package { 'capifony':
    ensure   => 'installed',
    provider => 'gem',
  }
}