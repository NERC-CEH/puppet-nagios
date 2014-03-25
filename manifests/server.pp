class nagios::server(
  $hosts = {},
  $services = {},
  $commands = {},
  $hosts_defaults = {},
  $services_defaults = {},
  $users_file = '/etc/nagios3/htpasswd.users'
) {
  package { 'nagios3' :
    ensure => installed,
  }

  package { 'nagios-nrpe-plugin' :
    ensure => installed,
    before => Service['nagios3'],
  }

  package { 'nagios-plugins' :
    ensure => installed,
    before => Service['nagios3'],
  }

  file { '/etc/nagios3/conf.d' :
    ensure  => directory,
    recurse => true,
    mode    => 644,
    require => Package['nagios3'],
  }
  
  file { '/etc/nagios' :
    ensure => link,
    target => '/etc/nagios3/conf.d',
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

  create_resources( nagios_host, $hosts, $hosts_defaults)
  create_resources( nagios_service, $services, $services_defaults)
  create_resources( nagios_command, $commands)
  
  # Gather the local resources
  Package['nagios3'] -> Nagios_host <||>    ~> Service['nagios3']
  Package['nagios3'] -> Nagios_service <||> ~> Service['nagios3']
  Package['nagios3'] -> Nagios_command <||> ~> Service['nagios3']

  # Gather the exported nagios resources 
  Package['nagios3'] -> Nagios_host <<||>>        ~> Service['nagios3']
  Package['nagios3'] -> Nagios_service <<||>>     ~> Service['nagios3']
  Package['nagios3'] -> Nagios_hostextinfo <<||>> ~> Service['nagios3']
}
