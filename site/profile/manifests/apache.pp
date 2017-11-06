class profile::apache (
  Hash $vhosts,
) {
  class { '::apache': }

  contain ::apache

  create_resources('::apache::vhost', $vhosts)

}
