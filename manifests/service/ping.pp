class nagios::check::ping (
  $args                 = '100.0,20%!500.0,60%',
  $notification_period  = '24x7',
  $service_description  = 'Ping',
  $use                  = 'generic-service'
) {

  @@nagios_service { "check_ping_${fqdn}":
    check_command       => "check_ping!${args}",
    use                 => 'generic-service',
    host_name           => $fqdn,
    notification_period => '24x7',
    service_description => 'Ping',
    target              => '/etc/nagios3/conf.d/service.cfg',
  }
}