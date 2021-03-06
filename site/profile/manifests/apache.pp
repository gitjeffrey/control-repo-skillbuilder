# Class to create a webserver.

class profile::apache (
  Hash $vhosts,
) {

  class { '::apache': }

  # deprecated
  #create_resources('::apache::vhost', $vhosts)

  $vhosts.each | String $key, Hash $value| {

    notify {"{PROGRAMMER_MSG}::apache::vhost \$key=${key}, \$value=${value}":}

    ::apache::vhost { $key:
      docroot    => $value['docroot'],
      port       => $value['port'],
      vhost_name => $value['vhost_name'],
      ip         => $value['ip'],
    }

  }

}
