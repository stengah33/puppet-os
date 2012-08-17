class os::opensuse {
 
  include os::opensuse::puppet

  # set hostname
  host {"$fqdn":
    ensure => present,
    ip => $ipaddress,
  }

}
