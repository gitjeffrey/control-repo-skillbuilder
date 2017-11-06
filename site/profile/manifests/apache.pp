class profile::apache (
  Hash $vhosts,
) {
  class { '::puppetlabs::apache': }

  contain ::puppetlabs::apache

  create_resources('::apache::vhost', $vhosts)

}
