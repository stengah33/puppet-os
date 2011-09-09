class os::debian {
  #
  # Default packages
  #
  package {
    "at":             ensure => present; # usefull for reboots...
    "bc":             ensure => present;
    "bash-completion":ensure => present;
    "bzip2":          ensure => present;
    "cadaver":        ensure => present;
    "cron-apt":       ensure => purged; # Keeps a fresh apt database
    "curl":           ensure => present;
    "cvs":            ensure => present;
    "elinks":         ensure => present;
    "emacs21-common": ensure => absent;
    "emacs23-nox":    ensure => present; # for fredj (this comes from backports on Lenny)
    "file":           ensure => present;
    "gettext":        ensure => present;
    "iotop":          ensure => present;
    "ipcalc":         ensure => present;
    "iproute":        ensure => present;
    "iptraf":         ensure => present;
    "less":           ensure => present;
    "locate":         ensure => absent;
    "lsof":           ensure => present;
    "lynx":           ensure => present;
    "mtr-tiny":       ensure => present;
    "ngrep":          ensure => present;
    "nmap":           ensure => present;
    "patch":          ensure => present;
    "psmisc":         ensure => present;
    "pwgen":          ensure => present;
    "rdiff-backup":   ensure => present;
    "rsync":          ensure => present;
    "screen":         ensure => present;
    "smartmontools":  ensure => present; # SMART monitoring
    "strace":         ensure => present;
    "tcpdump":        ensure => present;
    "tiobench":       ensure => present; # Useful for doing IO benchmarks
    "tofrodos":       ensure => present;
    "tshark":         ensure => present;
    "unzip":          ensure => present;
    "vim":            ensure => present;
    "whois":          ensure => present;
    "xfsprogs":       ensure => present;
    "zip":            ensure => present;
  }
  
  # Umask, etc.
  file { "/etc/profile":
    ensure => present,
    mode   => 644,
    source => "puppet:///os/etc/profile-debian",
  }

  file {"/etc/profile.d":
    ensure => directory
  }

  # Timezone
  file { "/etc/localtime":
    ensure => present,
    source => "file:///usr/share/zoneinfo/Europe/Zurich",
  }

  file { "/etc/timezone":
    ensure  => present,
    content => "Europe/Zurich\n",
  }

  # Kernel
  file { "/etc/modules":
    ensure => present,
  }

  file {"/etc/adduser.conf":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("os/etc/adduser.conf.erb"),
  }

  # $LANG
  file { "/etc/environment":
    ensure => present,
    mode   => 644,
    source => "puppet:///os/etc/environment",
    owner  => root,
    group  => root,
  }

}
