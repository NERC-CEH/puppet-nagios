class nagios::check::disk {
  nagios::check::nrpe { 'check_all_disk' :
    service_description => 'Disk Space',
    command             => '/usr/lib/nagios/plugins/check_disk -w 20% -c 10%'
  }
}