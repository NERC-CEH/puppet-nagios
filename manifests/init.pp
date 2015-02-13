# == Class: nagios
#
# Namespace for nagios module, it also defines the current platform specific
# defaults for file locations and names
#
# === Parameters
#
# [*user*] The user which the nrpe client and server should run as
# [*group*] The group which the nrpe client and server should run as
# [*manage_user*] If the user should be managed
# [*manage_group*] If the group should be managed
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class nagios (
  $user         = 'nagios',
  $group        = 'nagios',
  $manage_user  = true,
  $manage_group = true
) {
  $nrpe_package = $::kernel ? {
    Darwin  => 'nrpe',
    default => 'nagios-nrpe-server'
  }

  $package_provider = $::kernel ? {
    Darwin  => 'brew',
    default => undef
  }

  $nrpe_config = $::kernel ? {
    Darwin  => '/usr/local/etc/nrpe.cfg',
    default => '/etc/nagios/nrpe_local.cfg'
  }

  $nrpe_service = $::kernel ? {
    Darwin  => 'org.nrpe.agent',
    default => 'nagios-nrpe-server'
  }
  
  $plugins_path = $::kernel ? {
    'Darwin' => '/usr/local/opt/nagios-plugins/sbin'
    default  => '/usr/lib/nagios/plugins'
  }

  if $manage_user {
    user { $user :
      ensure => present,
    }
  }

  if $manage_group {
    group { $group :
      ensure => present,
    }
  }
}
