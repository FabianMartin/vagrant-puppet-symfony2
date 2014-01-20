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
  $setup_lsyncd         = false,
  $mysql_root_password = undef
)  {
  stage { 'apt-update': before => Stage['main'] }
  class { 'symfony2::apt-index-update': stage => 'apt-update' }

  include symfony2::system-setup
  case $mapping_type {
    system-link: { include symfony2::mapping::system-link }
    share: { include symfony2::mapping::share }
  }

  if $setup_mysql == true {
    class { "::mysql::server":
      root_password => $mysql_root_password,
      restart => true,
      service_enabled => true,
      override_options => { 'mysqld' => { 'bind-address' => '0.0.0.0' } }
    }

    mysql::db { 'symfony':
      user     => 'symfony',
      password => 'symfony',
      host     => '%',
      grant    => ['ALL'],
    }

    mysql_user { 'root@%':
      ensure                   => 'present',
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
    }

    mysql_grant { 'root@%/*.*':
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => '*.*',
      user       => 'root@%',
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

  if $setup_lsyncd == true and $mapping_type == "share" {
    include symfony2::lsynced-setup
  }
}