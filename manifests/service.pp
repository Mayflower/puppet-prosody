# == Class: prosody::service
class prosody::service(
  Optional[Boolean] $hasstatus = undef,
  Optional[String]  $restart   = undef,
) {

  if $prosody::daemonize {
    service { 'prosody':
      ensure    => running,
      enable    => true,
      hasstatus => $hasstatus,
      restart   => $restart,
      require   => Class[prosody::config],
    }
  }
}
