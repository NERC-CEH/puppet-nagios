class nagios::check::swap {
  nagios::check::nrpe { 'check_swap' :
    service_description => 'Swap Space',
    command             => '/usr/lib/nagios/plugins/check_swap -w 20 -c 10'
  }
}