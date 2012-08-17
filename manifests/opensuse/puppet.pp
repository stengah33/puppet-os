class os::opensuse::puppet {    
  include puppet::module::zypprepo
    
  zypprepo {"repo_add":
    baseurl => "http://download.opensuse.org/repositories/systemsmanagement:/puppet/openSUSE_$operatingsystemrelease/",
    enabled => 1,
    autorefresh => 1,
    name => "systemsmanagement_puppet",
    gpgcheck => 0,
    type => "rpm-md",
    keeppackages => 1,
  }
    
  exec {'zypper_dup':
    command => 'zypper -n -q dup -l -r systemsmanagement_puppet',
    path    => "/bin/:/usr/bin/:/usr/local/bin/:",
  }

  package {'facter':
    ensure => latest,
  }
    
  package {'puppet':
    ensure => latest,
  }

  Zypprepo['repo_add'] -> Exec['zypper_dup'] -> Package['facter'] -> Package['puppet']
}
