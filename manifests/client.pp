# == Class: nagios::client
#
# This class will set up a node to host nrpe commands which can be accessed
# for monitoring via your nagios server
#
# === Parameters
#
# [*nagios_server*] The $nagios_server which can access this node for monitoring
# [*nagios_version*] The version of nagios plugins to install
# [*nrpe_config*] The nrpe_config file to manage
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class nagios::client (
  $nagios_server,
  $nagios_version = installed,
  $nrpe_config    = $::nagios::nrpe_config
) {
  if ! defined(Class['::nagios']) {
    fail('You must include the nagios base class before nagios::client')
  }

  # Install nagios nrpe server and plugins
  package { ['nagios-plugins', $::nagios::nrpe_package] :
    ensure   => $nagios_version,
    provider => $::nagios::package_provider,
  }

  concat { $nrpe_config :
    require => Package[$::nagios::nrpe_package],
  }

  concat::fragment { "allowed_hosts ${nrpe_config}":
    target  => $nrpe_config,
    content => "allowed_hosts=${nagios_server}\n"
  }

  # On Mac OS X we need to link to the plist to create the nagios service
  if $::kernel == 'Darwin' {
    file { "/Library/LaunchDaemons/${::nagios::nrpe_service}.plist" :
      ensure => 'file',
      mode   => '0444',
      source => '/usr/local/opt/nrpe/homebrew.mxcl.nrpe.plist',
      before => Service[$::nagios::nrpe_service],
    }
  }

  # Keep the nrpe service running
  service { $::nagios::nrpe_service :
    ensure    => running,
    subscribe => File[$nrpe_config],
  }
}