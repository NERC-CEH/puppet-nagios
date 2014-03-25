class nagios::client (
  $nagios_server,
  $nagios_version = installed,
  $nrpe_config = '/etc/nagios/nrpe_local.cfg'
) {
  # Install nagios nrpe server and plugins
  package { ['nagios-plugins', 'nagios-nrpe-server'] :
    ensure => $nagios_version,
  }

  concat { $nrpe_config : 
    require => Package['nagios-nrpe-server'],
  }

  concat::fragment { "allowed_hosts ${nrpe_config}":
    target  => $nrpe_config,
    content => "allowed_hosts=${nagios_server}"
  }

  # Keep the nrpe service running
  service { 'nagios-nrpe-server': 
    ensure    => running,
    subscribe => File['/etc/nagios/nrpe_local.cfg'],
  }

  # Export this client as a nagios host. 
  @@nagios_host{ $fqdn :
    ensure  => present,
    alias   => $hostname,
    address => $ipaddress,
  }
}
