settings {
        logfile = "/var/log/lsyncd/lsyncd.log",
        statusFile = "/var/log/lsyncd/lsyncd-status.log", 
        statusInterval = 20
    }
sync {
    default.rsync,
    source="/var/www/", 
    target="/vagrant/",
}