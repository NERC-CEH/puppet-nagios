class nagios::check::load {
  nagios::check::nrpe { 'check_load' :
    service_description => 'Current Load',
    command             => '/usr/lib/nagios/plugins/check_load -w 15,10,5 -c 30,25,20'
  }
}