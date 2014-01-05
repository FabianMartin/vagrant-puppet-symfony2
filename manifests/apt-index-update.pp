# Class: symfony2::apt-update
#
#
class symfony2::apt-index-update {
  exec {"apt-get-update":
    command => "/usr/bin/apt-get update",
  }
}