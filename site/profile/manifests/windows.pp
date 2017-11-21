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

  include 'archive'

  #archive { '/tmp/7z1701-x64.exe':
  #  ensure       => present,
  #  source       => 'http://www.7-zip.org/a/7z1701-x64.msi',
  #  extract      => true,
  #  extract_path => '/tmp',
  #  creates      => '/tmp/7z1701-x64.msi',
  #  cleanup      => false,
  #}

  class { 'archive':
    namevar            => '7zip',
    seven_zip_name     => '7-Zip (x64 edition)',
    seven_zip_source   => 'http://www.7-zip.org/a/7z1701-x64.msi',
    seven_zip_provider => 'windows',
  }

  #archive { '/tmp/7z1701-x64.exe':
  #  source => 'http://www.7-zip.org/a/7z1701-x64.exe',
  #}

  reboot { 'after':
    subscribe => Archive['7zip'],
  }


  #staging::deploy { '7-zip':
  #  source => 'http://www.7-zip.org/a/7z1701-x64.exe',
  #}

}
