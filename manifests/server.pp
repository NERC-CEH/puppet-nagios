# == Class: nagios::server
#
# This class downloads and installs the nagios and sets up the nagios configuration files
# to configure.
#
# === Parameters
#
# [*version*] The version of nagios to install
# [*nrpe_version*] The version of nrpe-plugin to install
# [*plugins_version*] The version of the plugins to install
# [*users_file*] The location of the users file which can be managed with nagios::user
# [*config_files*] The config files which are to be managed by puppet (sets these to mode 644)
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
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

  # Verify that the nagios configuration is in a good state before restarting
  exec { 'nagios3-verify' :
    path        => '/usr/sbin',
    command     => 'nagios3 -v /etc/nagios3/nagios.cfg',
    refreshonly => true,
    notify      => Service['nagios3'],
  }

  service { 'nagios3' :
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['nagios3'],
  }
  
  # Gather the local resources
  Package['nagios3'] -> Nagios_command <||>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_contact <||>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_contactgroup <||>      ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_host <||>              ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostdependency <||>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostescalation <||>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostextinfo <||>       ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostgroup <||>         ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_service <||>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_servicedependency <||> ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_serviceescalation <||> ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_serviceextinfo <||>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_servicegroup <||>      ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_timeperiod <||>        ~> Exec['nagios3-verify']

  # Gather the exported nagios resources 
  Package['nagios3'] -> Nagios_command <<||>>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_contact <<||>>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_contactgroup <<||>>      ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_host <<||>>              ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostdependency <<||>>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostescalation <<||>>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostextinfo <<||>>       ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_hostgroup <<||>>         ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_service <<||>>           ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_servicedependency <<||>> ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_serviceescalation <<||>> ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_serviceextinfo <<||>>    ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_servicegroup <<||>>      ~> Exec['nagios3-verify']
  Package['nagios3'] -> Nagios_timeperiod <<||>>        ~> Exec['nagios3-verify']
}
