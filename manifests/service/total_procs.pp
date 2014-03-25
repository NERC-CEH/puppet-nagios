class nagios::check::total_procs (
  $warning             = 150,
  $critical            = 200,
  $service_description = 'Total Processes'
) {
  nagios::check::nrpe { 'check_total_procs' :
    service_description => $service_description,
    command             => "/usr/lib/nagios/plugins/check_procs -w ${warning} -c ${critical}",
  }
}