# Base Windows configuration class.

class profile::windows (
) {

  #notify {'The profile::windows class says hi!':}

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

  class { '::archive':
    seven_zip_name     => '7-Zip (x64 edition)',
    seven_zip_source   => 'http://www.7-zip.org/a/7z1701-x64.msi',
    seven_zip_provider => 'windows',
    notify             => Reboot['after'],
  }
  -> reboot { 'after': }

}
