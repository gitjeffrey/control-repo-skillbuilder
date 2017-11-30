# /etc/puppetlabs/code/environments/production/modules/profile/manifests/http_test.pp
class profile::http_test (
  Boolean             $param1,
  Boolean             $param2,
) {
  file { '/tmp/http_test.txt':
    ensure  => file,
    content => @("END"),
               Data from profile::hiera_test
               -----
               profile::http_test::param1: ${param1}
               profile::http_test::param2: ${param2}
               |END
    owner   => root,
    mode    => '0777',
  }
}
