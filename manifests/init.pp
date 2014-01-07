class symfony2(
  $mapping_type         = "system",
  $setup_mysql          = false,
  $setup_memcache       = false,
  $setup_nginx          = false,
  $setup_composer       = false,
  $setup_php            = false,
  $setup_capifony       = false,
  $setup_less           = false,
  $setup_git            = false,

  $mysql_root_password = undef
)  {
  stage { 'apt-update': before => Stage['main'] }
  class { 'symfony2::apt-index-update': stage => 'apt-update' }

  case $mapping_type {
      system-link: { include symfony2::mapping::system-link }
      share: { include symfony2::mapping::share }
    }

  if $setup_mysql == true {
    class { "::mysql::server":
      root_password => $mysql_root_password,
      restart => true,
      service_enabled => true,
    }

    mysql::db { 'symfony':
      user     => 'symfony',
      password => 'symfony',
      host     => 'localhost',
      grant    => ['ALL'],
    }
  }

  if $setup_memcache == true {
    package { "memcached":
      ensure => present,
      require => Exec["apt_update"]
    }
  }

  if $setup_nginx == true {
   include symfony2::nginx-setup
  }

  if $setup_php == true {
    include symfony2::php-setup
  }

  if $setup_php == true and $setup_composer == true {
    include symfony2::composer-setup
  }
  
  if $setup_capifony == true {
    include symfony2::capifony-setup
  }

  if $setup_less == true {
    include symfony2::less-setup
  }

  if $setup_git == true {
    include symfony2::git-setup
  }


}