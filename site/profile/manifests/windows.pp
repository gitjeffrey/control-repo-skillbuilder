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
  #  source       => 'http://www.7-zip.org/a/7z1701-x64.exe',
  #  extract      => true,
  #  extract_path => '/tmp',
  #  creates      => '/tmp/7z1701-x64.exe',
  #  cleanup      => false,
  #}

  archive { '/tmp/7z1701-x64.exe':
    source => 'http://www.7-zip.org/a/7z1701-x64.exe',
  }

  reboot { 'after':
    subscribe => Archive['/tmp/7z1701-x64.exe'],
  }


  #staging::deploy { '7-zip':
  #  source => 'http://www.7-zip.org/a/7z1701-x64.exe',
  #}

}
