# Class for installing mysql

class profile::mysql (
  Hash $databases,
) {

  include ::mysql::server

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
