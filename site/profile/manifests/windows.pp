# Base Windows configuration class.

class profile::windows (
) {

  notify {'profile::windows b4 user resource.':}

  user { 'winpup':
    ensure   => 'present',
    password => 'puppet',
  }

  file { 'c:/tmp/':
    ensure => 'directory',
    path   => 'c:/tmp/',
    owner  => 'winpup',
    group  => 'wingrp',
  }

}
