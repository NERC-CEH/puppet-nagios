define nagios::user (
  $cryptpasswd,
  $username = $name,
  $users_file = $nagios::server::users_file
) {

  htpasswd { "${name} ${users_file}" :
    username    => $username,
    cryptpasswd => $cryptpasswd,
    target      => $users_file,
    require     => Package['nagios3'],
  }
}
