# == Class: nagios
#
# Namespace for nagios module, it also defines the current platform specific
# defaults for file locations and names
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class nagios {
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
}
