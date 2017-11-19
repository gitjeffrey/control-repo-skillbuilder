# Base Windows configuration class.

class profile::windows (
) {

  notify {'profile::windows b4 user resource.':}

  user { 'winpup':
    ensure   => 'present',
    password => 'Puppet123.',
  }

  group { 'wingrp':
    ensure          => 'present',
    name            => 'wingrp',
    auth_membership => false,
    members         => 'winpup',
  }

  file { 'c:/tmp/':
    ensure => 'directory',
    path   => 'c:/tmp/',
    owner  => 'winpup',
    group  => 'wingrp',
  }

}
