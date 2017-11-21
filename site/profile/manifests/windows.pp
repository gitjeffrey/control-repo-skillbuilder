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

  archive { '7-zip':
    source       => 'http://www.7-zip.org/a/7z1701-x64.exe',
    extract      => true,
    extract_path => '/tmp',
    creates      => '/tmp/7z1701-x64.exe',
    cleanup      => false,
  }

  reboot { 'after':
    subscribe       => Archive['7-zip'],
  }


  #staging::deploy { '7-zip':
  #  source => 'http://www.7-zip.org/a/7z1701-x64.exe',
  #}

}
