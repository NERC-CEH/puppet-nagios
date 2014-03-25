class nagios::check::zombie_procs (
  $warning             = 5,
  $critical            = 10,
  $service_description = 'Zombie Processes'
) {
  nagios::check::nrpe { 'check_zombie_procs' :
    service_description => $service_description,
    command             => "/usr/lib/nagios/plugins/check_procs -w ${warning} -c ${critical} -s Z",
  }
}