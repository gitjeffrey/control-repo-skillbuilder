# Base Windows configuration class.

class profile::windows (
) {

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
