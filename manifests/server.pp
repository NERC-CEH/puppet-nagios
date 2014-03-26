class nagios::server(
  $version         = installed,
  $nrpe_version    = installed,
  $plugins_version = installed,
  $users_file      = '/etc/nagios3/htpasswd.users'
) {
  package { 'nagios3' :
    ensure => $version,
  }

  package { 'nagios-nrpe-plugin' :
    ensure => $nrpe_version,
    before => Service['nagios3'],
  }

  package { 'nagios-plugins' :
    ensure => $plugins_version,
    before => Service['nagios3'],
  }

  file { '/etc/nagios3/conf.d' :
    ensure  => link,
    force   => true,
    target  => '/etc/nagios',
    require => Package['nagios3'],
  }
  
  file { '/etc/nagios' :
    ensure  => directory,
    recurse => true,
    mode    => 644,
  }

  concat { $users_file :
    require => Package['nagios3'],
  }

  service { 'nagios3' :
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['nagios3'],
  }
  
  # Gather the local resources
  Package['nagios3'] -> Nagios_command <||>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_contact <||>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_contactgroup <||>      ~> Service['nagios3']
  Package['nagios3'] -> Nagios_host <||>              ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostdependency <||>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostescalation <||>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostextinfo <||>       ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostgroup <||>         ~> Service['nagios3']
  Package['nagios3'] -> Nagios_service <||>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_servicedependency <||> ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceescalation <||> ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceextinfo <||>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceextgroup <||>   ~> Service['nagios3']
  Package['nagios3'] -> Nagios_timeperiod <||>        ~> Service['nagios3']

  # Gather the exported nagios resources 
  Package['nagios3'] -> Nagios_command <<||>>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_contact <<||>>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_contactgroup <<||>>      ~> Service['nagios3']
  Package['nagios3'] -> Nagios_host <<||>>              ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostdependency <<||>>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostescalation <<||>>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostextinfo <<||>>       ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostgroup <<||>>         ~> Service['nagios3']
  Package['nagios3'] -> Nagios_service <<||>>           ~> Service['nagios3']
  Package['nagios3'] -> Nagios_servicedependency <<||>> ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceescalation <<||>> ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceextinfo <<||>>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_serviceextgroup <<||>>   ~> Service['nagios3']
  Package['nagios3'] -> Nagios_timeperiod <<||>>        ~> Service['nagios3']
}
