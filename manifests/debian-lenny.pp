class os::debian-lenny {

  include os::debian

  # Disable PC Speaker
  common::line {"disable pc speaker":
    line   => 'blacklist pcspkr',
    file   => '/etc/modprobe.d/blacklist',
    ensure => present,
  }

  # general config for emacs (without temporary files ~ )
  file { "/etc/emacs/site-start.d/50c2c.el":
    ensure  => present,
    mode    => 644,
    source  => "puppet:///modules/os/etc/emacs/site-start.d/50c2c.el",
    require => Package["emacs23-nox"]
  }

  apt::preferences { "c2c-mirror":
    ensure => present,
    package => "*",
    pin => "release o=c2c",
    priority => "1001",
  }

  #
  # Locales
  #

  package {"locales-all":
    ensure => absent,
  }

  package {"locales":
    ensure => present,
    require => File["/etc/locale.gen"],
    notify => Exec["locale-gen"],
  }

  file {"/etc/locale.gen":
    ensure  => present,
    source  => "puppet:///modules/os/locale.gen",
    notify => Exec["locale-gen"],
  }

  exec {"locale-gen":
    refreshonly => true,
    command => "locale-gen",
    timeout => 30,
    require => [File["/usr/share/locale/locale.alias"], Package["locales"], File["/etc/locale.gen"]],
  }

  # BUG: Smells hacky ?
  file {"/usr/share/locale/locale.alias":
    ensure => present,
    source => "puppet:///modules/os/locale.alias",
  }

  # SSL Configuration
  package {
    "ca-certificates": ensure => present;
  }

  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  exec {"sysctl-reload":
    command     => "sysctl -p",
    refreshonly => true,
  }

  # fix 14573
  package {"debian-archive-keyring":
    ensure => latest,
  }

  # fixes rt#14979
  cron {"Keeps a fresh apt database":
    command  => "/usr/bin/apt-get update -q=2",
    ensure   => present,
    hour     => 4,
    minute   => ip_to_cron(1),
  }
}
