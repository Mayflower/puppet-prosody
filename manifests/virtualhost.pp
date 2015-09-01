define prosody::virtualhost(
  $ensure='present',
  $ssl_key=undef,
  $ssl_cert=undef
) {
  if (($ssl_key != undef) and ($ssl_cert == undef)) {
    fail('The prosody::virtualhost type needs both ssl_key *and* ssl_cert set')
  }
  if (($ssl_key == undef) and ($ssl_cert != undef)) {
    fail('The prosody::virtualhost type needs both ssl_key *and* ssl_cert set')
  }

  if (($ssl_key != undef) and ($ssl_cert != undef)) {
    $config_requires = [File[$ssl_key], File[$ssl_cert], Class[prosody::package]]
  }
  else {
    $config_requires = Class[prosody::package]
  }

  if defined(Service['prosody']) {
    $cfg_notify = Service['prosody']
  }
  else {
    $cfg_notify = undef
  }

  file { "${name}.cfg.lua":
    ensure  => $ensure,
    require => $config_requires,
    path    => "/etc/prosody/conf.avail/${name}.cfg.lua",
    content => template('prosody/virtualhost.cfg.erb'),
    notify  => $cfg_notify,
  }

  $cfg_ensure = $ensure ? {
      'present' => link,
      'absent'  => absent,
    }

  file { "/etc/prosody/conf.d/${name}.cfg.lua":
    ensure  => $cfg_ensure,
    target  => "/etc/prosody/conf.avail/${name}.cfg.lua",
    notify  => $cfg_notify,
    require => File["${name}.cfg.lua"];
  }
}
