class nagios::command_jolokia {

  ::apt::source { 'gekkio-jmx4perl' :
    location   => 'http://ppa.launchpad.net/gekkio/jmx4perl/ubuntu',
    repos      => 'main',
    key        => '0B20AE72',
    key_server => 'keyserver.ubuntu.com',
  }

  package { 'jmx4perl' :
    ensure  => installed,
    before  => Service['nagios3'],
    require => ::Apt::Source['gekkio-jmx4perl'],
  }

  nagios_command { 'check_j4p_HeapMemory':
    command_line => '/usr/lib/nagios/plugins/check_jmx4perl --url http://$HOSTNAME$:$ARG1$ --mbean java.lang:type=Memory --attribute HeapMemoryUsage --path used --base java.lang:type=Memory/HeapMemoryUsage/max --warning 80 --critical 90',
  }
}
