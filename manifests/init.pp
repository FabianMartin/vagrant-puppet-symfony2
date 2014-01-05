class symfony2(
  $local_mapping        = false,
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

  if $local_mapping == true {
    # Bind mount sf2 cache and log directories to local directories. We can't
    # put those on the shared folder because firstly, PHP rund under www-data
    # and /vagrant belongs to vagrant. Secondly, putting many and/or large files
    # on vboxsf is a bad idea
    file { ["/tmp/sf2", "/tmp/sf2/cache", "/tmp/sf2/logs", "/tmp/sf2/bundles", "/tmp/sf2/vendor"]:
      ensure => directory,
      # user www-data comes with the nginx package so we require it here
      require => Package["nginx"],
      owner => "vagrant",
      mode => 777,
    }

    file { ["/vagrant/app/cache", "/vagrant/app/logs", "/vagrant/web/bundles", "/vagrant/vendor"]:
      ensure => directory,
    }

    temp_bind_mount { "sf2-cache":
      source => "/tmp/sf2/cache",
      dest   => "/vagrant/app/cache",
    }

    temp_bind_mount { "sf2-logs":
      source => "/tmp/sf2/logs",
      dest   => "/vagrant/app/logs",
    }

    temp_bind_mount { "sf2-bundles":
      source => "/tmp/sf2/bundles",
      dest   => "/vagrant/web/bundles",
    }

    temp_bind_mount { "sf2-vendor":
      source => "/tmp/sf2/vendor",
      dest   => "/vagrant/vendor",
    }
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

  # We can't use puppet's built in 'mount' resource since that
  # would generate an entry in /etc/fstab. But the target doesn't
  # exist at boot time since Vagrant has yet to mount it, so
  # rebooting will fail.
  define temp_bind_mount ( $dest = $title, $source ) {
    exec { "bind_mount_${title}":
      command => "mount --bind ${source} ${dest}",
      path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
      unless => "grep -q ${dest} /etc/mtab 2>/dev/null",
      require => [File[$dest], File[$source]],
    }
  }
}