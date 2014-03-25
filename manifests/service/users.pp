class nagios::check::users (
  $warning             = 5,
  $critical            = 10,
  $service_description = 'Current Users'
) {
  nagios::check::nrpe { 'check_users' :
    service_description => $service_description,
    command             => "/usr/lib/nagios/plugins/check_users -w ${warning} -c ${critical}",
  }
}