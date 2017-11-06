class role::lamp {
  include profile::apache
  include profile::mysql

  Class['::profile::apache']
  -> Class['::profile::mysql']
}
