class profile::mysql (
  String $root_password,
  Boolean $remove_default_accounts,
  Hash $override_options,
  Hash $databases,
) {

  class { '::mysql::server':
    root_password           => $value['root_password'],
    remove_default_accounts => $value['remove_default_accounts'],
    override_options        => $override_options,
  }

  $databases.each | String $key, Hash $value| {

    notify {"{PROGRAMMER_MSG}::mysql::db \$key=${key}, \$value=${value}":}

    mysql::db { $key:
      user     => $value['user'],
      password => $value['pass'],
      host     => $value['host'],
      grant    => $value['grant'],
    }

  }

}
