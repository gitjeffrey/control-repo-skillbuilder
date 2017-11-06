class profile::apache (
  Hash $vhosts,
) {
  class { '::apache': }

  #create_resources('::apache::vhost', $vhosts)

  $vhosts.each | String $key, Hash $value| {

    ::apache::vhost { $key:
      docroot => $value['docroot'],
    }
  }
}
