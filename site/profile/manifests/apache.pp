class profile::apache (
  Hash $vhosts,
) {
  class { '::apache': }

  contain ::apache

  create_resources('::apache::vhost', $vhosts)

  apache::vhost { 'vhost.example.com':
    port    => '80',
    docroot => '/var/www/vhost',
  }

}
