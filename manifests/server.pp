class nagios::server(
  $version         = installed,
  $nrpe_version    = installed,
  $plugins_version = installed,
  $users_file      = '/etc/nagios3/htpasswd.users',
  $config_files = [
    '/etc/nagios/nagios_command.cfg',
    '/etc/nagios/nagios_contact.cfg',
    '/etc/nagios/nagios_contactgroup.cfg',
    '/etc/nagios/nagios_host.cfg',
    '/etc/nagios/nagios_hostdependency.cfg',
    '/etc/nagios/nagios_hostescalation.cfg',
    '/etc/nagios/nagios_hostextinfo.cfg',
    '/etc/nagios/nagios_hostgroup.cfg',
    '/etc/nagios/nagios_service.cfg',
    '/etc/nagios/nagios_servicedependency.cfg',
    '/etc/nagios/nagios_serviceescalation.cfg',
    '/etc/nagios/nagios_serviceextinfo.cfg',
    '/etc/nagios/nagios_servicegroup.cfg',
    '/etc/nagios/nagios_timeperiod.cfg'
  ]
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
    purge   => true,
  }
  
  # Set all of the config files to the correct mode
  file { $config_files :
    mode   => 644,
    ensure => present,
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
  Package['nagios3'] -> Nagios_servicegroup <||>      ~> Service['nagios3']
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
  Package['nagios3'] -> Nagios_servicegroup <<||>>      ~> Service['nagios3']
  Package['nagios3'] -> Nagios_timeperiod <<||>>        ~> Service['nagios3']
}
