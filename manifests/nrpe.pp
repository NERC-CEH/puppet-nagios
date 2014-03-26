define nagios::nrpe (
  $command,
  $service_description,
  $notification_period = $nagios::check::default_notification_period,
  $host_name = $fqdn,
  $command_name = $name,
  $use = 'generic-service'
) {
  concat::fragment { "command ${name} ${nagios::client::nrpe_config}":
    target  => $::nagios::client::nrpe_config,
    content => "command[${name}]=${command}\n",
  }

  @@nagios_service { "${command_name}_${fqdn}" :
    check_command       => "check_nrpe_1arg!${command_name}",
    use                 => $use,
    host_name           => $host_name,
    notification_period => $notification_period,
    service_description => $service_description,
  }
}
