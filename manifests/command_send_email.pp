class nagios::command_sendemail (
  $smtp_server,
  $email_address,
  $manage_package     = true,
  $sendemail_version  = installed
) {

  if $manage_package {
    package { 'sendemail' :
      ensure => $send_email_version,
    }
  }
  
  nagios_command { 'notify-host-by-sendemail':
    command_line => template('nagios/command_notifyHostBySendEmail.erb'),
  }

  nagios_command { 'notify-service-by-sendemail':
    command_line => template('nagios/command_notifyServiceBySendEmail.erb'),
  }
}