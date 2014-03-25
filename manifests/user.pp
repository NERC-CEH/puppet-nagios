define nagios::user (
  $cryptpasswd,
  $username = $name,
  $users_file = $nagios::server::users_file
) {

  concat::fragment { "${name} ${users_file}" :
    target  => $users_file,
    content => "${username}:${cryptpasswd}",
    require => Package['nagios3'],
  }
}
