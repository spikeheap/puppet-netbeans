class netbeans( 
  $ensure = 'present',
  $netbeans_version = '7.3.1'
) {
  
  $install_base = "/opt/netbeans"
  $install_location = "${$install_base}/${netbeans_version}/"
  $options = "--silent \"-J-Dnb-base.installation.location=${install_location}\""
  
  # Only support Ubuntu at the moment
  if $osfamily == 'Debian'{

    # All of the following should be refactored
    # into a script-based provider
    
    if $ensure == 'present'{
      file{ $install_base:
        ensure => 'directory',
      }
      -> file{ $install_location:
        ensure => 'directory',
      }
      -> exec{"download_netbeans_${netbeans_version}":
        command => "/usr/bin/wget --output-document /tmp/netbeans-${netbeans_version}-linux.sh http://download.netbeans.org/netbeans/${netbeans_version}/final/bundles/netbeans-${netbeans_version}-linux.sh",
        unless  => "/usr/bin/test -f /tmp/netbeans-${netbeans_version}-linux.sh",
        require => [ Package["wget"] ],
      }
      -> exec{"install_netbeans_${netbeans_version}":
        command => "/bin/bash /tmp/netbeans-${netbeans_version}-linux.sh ${options}",
        unless  => "/usr/bin/test -d /opt/netbeans/${netbeans_version}/",
      }
    }
    else{
      file{ $install_location:
        ensure => $ensure,
      }
    }
  }
}
