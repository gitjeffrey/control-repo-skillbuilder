# Base Windows configuration class.

class profile::windows (
) {

  user { 'winpup':
    ensure   => 'present',
    password => 'puppet',
  }

}
