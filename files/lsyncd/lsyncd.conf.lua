settings = {
    logfile = "/var/log/lsyncd.log",
    statusFile = "/var/log/lsyncd-status.log", 
    statusInterval = 10
}
sync {
    default.rsync,
    source = "/var/www/project/", 
    target = "/vagrant/",
    exclude = { "app/logs", "app/cache", "vendor", ".git", ".idea" }
}