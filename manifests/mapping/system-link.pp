class symfony2::mapping::system-link {
  file { ["/tmp/sf2", "/tmp/sf2/cache", "/tmp/sf2/logs", "/tmp/sf2/bundles", "/tmp/sf2/vendor"]:
    ensure => directory,
    require => Package["nginx"],
    owner => "www-data",
    mode => 777,
  }

  file { ["/var/www/app", "/var/www/app/cache", "/var/www/app/logs","/var/www/web" , "/var/www/web/bundles", "/var/www/vendor"]:
    ensure => directory,
    owner => "www-data",
    mode => 777,
  }

  temp_bind_mount { "sf2-cache":
    source => "/tmp/sf2/cache",
    dest   => "/var/www/app/cache",
  }

  temp_bind_mount { "sf2-logs":
    source => "/tmp/sf2/logs",
    dest   => "/var/www/app/logs",
  }

  temp_bind_mount { "sf2-bundles":
    source => "/tmp/sf2/bundles",
    dest   => "/var/www/web/bundles",
  }

  temp_bind_mount { "sf2-vendor":
    source => "/tmp/sf2/vendor",
    dest   => "/var/www/vendor",
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