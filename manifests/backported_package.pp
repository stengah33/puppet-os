define os::backported_package( $ensure, $responsefile="", $install=true) {

  if $install == true {
  
    if defined(Package[$name]) {
      debug "Package $name already exists"
    } else {
      case $responsefile {
        "" : {
          package {$name:
            ensure => $ensure,
          }
        }
        default : {
          package {$name:
            ensure       => $ensure,
            responsefile => $responsefile
          }
        }
      }
    }
  }
  case $ensure {
    'present','latest','installed': {
      concat::fragment {$name:
        ensure  => present,
        content => "Package: ${name}\nPin: release a=${lsbdistcodename}-backports\nPin-Priority: 999\n\n",
        target  => "/etc/apt/preferences",
        before  => Package[$name],
      }
    }
    'absent','purged': {
      concat::fragment {$name:
        ensure  => absent,
        content => "Package: ${name}\nPin: release a=${lsbdistcodename}-backports\nPin-Priority: 999\n\n",
        target  => "/etc/apt/preferences",
        before  => Package[$name],
      }
    }
    default: { fail "Unknown status $ensure for os::backported_package $name"}
  }


}
