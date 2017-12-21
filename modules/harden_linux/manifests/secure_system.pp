# Class ::harden_linux::secure_system
# Harden a system (node) to Department of Defense STIG standards.

class harden_linux::secure_system (
  Boolean $log = false,
) {

  # Turn log messages on/off for this manifest
  $logging = $::harden_linux::secure_system::log

  # V-71849
  $rpm_system_files = $facts['dod_rpm_system_files']

  if $rpm_system_files != undef {

    $rpm_system_files.each |String $rpm_filename, String $rpm_package| {

      # Ask rpm package to reset file permissions and owner to match rpm spec...
      # Logic below will result in repeated calls to an rpm package,
      # if that package has multiple files with mismatched permissions.
      # Quicker runtime if this is refactored to run once per package
      # (unless package manager optimizes these calls already).
      if ($rpm_package != '') {

        exec { "rpm --setperms ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        exec { "rpm --setugids ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {

          warning("${facts['fqdn']}: *** DoD Hardening *** V-71849 vulnerability fix applied. \
[Details: set group/user file permissions: rpm_packagename=${rpm_package}, rpm_filename=${rpm_filename}]")

          notify { "logmsg_file_perm_${rpm_package}_${rpm_filename}":
            withpath => false,
            message  => "*** DoD Hardening *** V-71849 vulnerability fix applied. \
[Details: set group/user file permissions: rpm_packagename=${rpm_package}, rpm_filename=${rpm_filename}]",
            loglevel => warning,
          }

        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71849 vulnerability fix applied. [Details: no files to process.]")

      notify { 'logmsg_file_perm_no_files':
        withpath => false,
        message  => '*** DoD Hardening *** V-71849 vulnerability fix applied. [Details: no files to process.]',
        loglevel => warning,
      }

    }

  }


  # V-71855
  $rpm_files_check_hash = $facts['dod_rpm_files_check_hash']

  if $rpm_files_check_hash != undef {

    $rpm_files_check_hash.each |String $rpm_filename, String $rpm_package| {

      if ($rpm_package != '') {

        # Ask rpm to check the cryptographic hash of system files it installed.
        exec { "rpm -Uvh ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {

          warning("${facts['fqdn']}: *** DoD Hardening *** V-71855 vulnerability fix applied. \
[Details: Fix modified file hash: rpm_packagename=${rpm_package}, rpm_filename=${rpm_filename}]")

          notify { "logmsg_chk_hash_${rpm_package}_${rpm_filename}":
            withpath => false,
            message  => "*** DoD Hardening *** V-71855 vulnerability fix applied. \
[Details: Fix modified file hash: rpm_packagename=${rpm_package}, rpm_filename=${rpm_filename}]",
            loglevel => warning,
          }

        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71855 vulnerability fix applied. [Details: no files to process.]")

      notify { 'logmsg_no_files_chk_hash':
        withpath => false,
        message  => '*** DoD Hardening *** V-71855 vulnerability fix applied. [Details: no files to process.]',
        loglevel => warning,
      }

    }

  }


  # V-71859, V-71861, V-71891, V-71893, V-71895, V-71899, V-71901
  #
  # Sources:
  # https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
  # https://help.gnome.org/admin/system-admin-guide/stable/desktop-lockscreen.html.en
  #
  # Note:
  # The example below is using the database "local" for the system,
  # so the path is "/etc/dconf/db/local.d". This path must be modified if
  # a database other than "local" is being used.

  $short_banner_msg = "I've read & consent to terms in IS user agreem't."

  $banner_msg = "You are accessing a U.S. Government (USG) Information System (IS) \
that is provided for USG-authorized use only.\nBy using this IS (which \
includes any device attached to this IS), you consent to the following \
conditions:\n-The USG routinely intercepts and monitors communications \
on this IS for purposes including, but not limited to, penetration testing, \
COMSEC monitoring, network operations and defense, personnel misconduct (PM), \
law enforcement (LE), and counterintelligence (CI) investigations.\n-At any \
time, the USG may inspect and seize data stored on this IS.\n-Communications \
using, or data stored on, this IS are not private, are subject to routine \
monitoring, interception, and search, and may be disclosed or used for any \
USG-authorized purpose.\n-This IS includes security measures (e.g., \
authentication and access controls) to protect USG interests--not for \
your personal benefit or privacy.\n-Notwithstanding the above, using this \
IS does not constitute consent to PM, LE or CI investigative searching or \
monitoring of the content of privileged communications, or work product, \
related to personal representation or services by attorneys, \
psychotherapists, or clergy, and their assistants. Such communications and \
work product are private and confidential. See User Agreement for details. \n"

  if ($facts['dod_gnome_version_file_exists']) {

    # Note: the \n escape character didn't work for this config file...
    file { '/etc/dconf/profile/gdm':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0622',
      backup  => '.b4.dod',
      content => "user-db:user
system-db:local
system-db:site
system-db:distro
file-db:/usr/share/gdm/greeter-dconf-defaults",
    }

    file { '/etc/dconf/db/local.d/01-banner-message':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.b4.dod',
      content => "[org/gnome/login-screen]\nbanner-message-enable=true\nbanner-message-text='${banner_msg}'",
    }

    # V-71891, V-71899, V-71901
    file { '/etc/dconf/db/local.d/00-screensaver':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.b4.dod',
      content => "[org/gnome/desktop/session]
idle-delay=uint32 900

[org/gnome/desktop/screensaver]
idle-activation-enabled=true
lock-enabled=true
lock-delay=uint32 5",
    }

    # V-71895
    # lock screensaver settings to prevent user override...
    file { '/etc/dconf/db/local.d/locks/screensaver':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.b4.dod',
      content => "# Lock desktop screensaver settings
/org/gnome/desktop/session/idle-delay
/org/gnome/desktop/screensaver/lock-enabled
/org/gnome/desktop/screensaver/lock-delay",
    }

    exec { 'dconf update':
      path    => ['/usr/bin', '/usr/sbin'],
      require => File['/etc/dconf/db/local.d/00-screensaver'],
    }

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71859, V-71861, V-71891, \
V-71899, V-71901 vulnerability fixes applied. [Details: GNOME screensaver configuration complete.]")

      notify { 'logmsg_gnome_scrsvr':
        withpath => false,
        message  => "*** DoD Hardening *** V-71859, V-71861, V-71891, V-71899, \
V-71901 vulnerability fixes applied. [Details: GNOME screensaver configuration complete.]",
        loglevel => warning,
      }

    }

  }


  # V-71863
  file { '/etc/issue':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0622',
    backup  => '.b4.dod',
    content => $banner_msg,
  }

  if $::harden_linux::secure_system::logging {

    warning("${facts['fqdn']}: *** DoD Hardening *** V-71863 vulnerability fix applied. [Details: /etc/issue content changed.]")

    notify { 'logmsg_etc_issue':
      withpath => false,
      message  => '*** DoD Hardening *** V-71863 vulnerability fix applied. [Details: /etc/issue content changed.]',
      loglevel => warning,
    }

  }


  # V-71897
  if (!$facts['dod_yum_installed_screen_package']) {

    # Added the -y option to answer yes to any prompts, else it fails.
    exec { 'yum -y install screen':
      path    => ['/usr/bin', '/usr/sbin'],
    }

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71897 vulnerability fix applied. [Details: screen package installed.]")

      notify { 'logmsg_screen_pkg':
        withpath => false,
        message  => '*** DoD Hardening *** V-71897 vulnerability fix applied. [Details: screen package installed.]',
        loglevel => warning,
      }

    }

  }


  # V-71903, V-71905, V-71907, V-71909, V-71911, V-71913, V-71915, V-71917

  $pwquality_conf = "# Configuration for systemwide password quality limits
# Defaults:
#
# Number of characters in the new password that must not be present in the
# old password.
difok = 8
#
# Minimum acceptable size for the new password (plus one if
# credits are not disabled which is the default). (See pam_cracklib manual.)
# Cannot be set to lower value than 6.
# minlen = 9
#
# The maximum credit for having digits in the new password. If less than 0
# it is the minimum number of digits in the new password.
dcredit = -1
#
# The maximum credit for having uppercase characters in the new password.
# If less than 0 it is the minimum number of uppercase characters in the new
# password.
ucredit = -1
#
# The maximum credit for having lowercase characters in the new password.
# If less than 0 it is the minimum number of lowercase characters in the new
# password.
lcredit = -1
#
# The maximum credit for having other characters in the new password.
# If less than 0 it is the minimum number of other characters in the new
# password.
ocredit = -1
#
# The minimum number of required classes of characters for the new
# password (digits, uppercase, lowercase, others).
minclass = 4
#
# The maximum number of allowed consecutive same characters in the new password.
# The check is disabled if the value is 0.
maxrepeat = 3
#
# The maximum number of allowed consecutive characters of the same class in the
# new password.
# The check is disabled if the value is 0.
maxclassrepeat = 4
#
# Whether to check for the words from the passwd entry GECOS string of the user.
# The check is enabled if the value is not 0.
# gecoscheck = 0
#
# Path to the cracklib dictionaries. Default is to use the cracklib default.
# dictpath ="

  file { '/etc/security/pwquality.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0622',
    backup  => '.b4.dod',
    content => $pwquality_conf,
  }

  if $::harden_linux::secure_system::logging {

    warning("${facts['fqdn']}: *** DoD Hardening *** V-71903, V-71905, V-71907, V-71909, V-71911,\
V-71913, V-71915, V-71917 vulnerability fixes applied. [Details: pwquality.conf settings updated.]")

    notify { 'logmsg_pwquality_conf':
      withpath => false,
      message  => "*** DoD Hardening *** V-71903, V-71905, V-71907, V-71909, V-71911,\
V-71913, V-71915, V-71917 vulnerability fixes applied. [Details: pwquality.conf settings updated.]",
      loglevel => warning,
    }

  }


  # V-71919
  # Red Hat 7 Security Guide recommends turning on shadow passwords,
  # the /etc/shadow file is only read by root, whereas /etc/passwd is readable by everyone.
  # Not sure why the "shadow" keyword was left off the DOD STIG.
  # Adding "shadow" to:
  # password sufficient pam_unix.so sha512
  # password sufficient pam_unix.so sha512 shadow
  #
  # Source:
  # https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/chap-hardening_your_system_with_tools_and_services

  # password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok

  file_line { '/etc/pam.d/system-auth-ac':
      ensure  => present,
      replace => true,
      path    => '/etc/pam.d/system-auth-ac',
      match   => '^password\s+sufficient\s+pam_unix\.so',
      line    => 'password sufficient pam_unix.so sha512 shadow',
  }

  if $::harden_linux::secure_system::logging {

    warning("${facts['fqdn']}: *** DoD Hardening *** V-71919 vulnerability fix applied. \
[Details: Set 'password sufficient pam_unix.so sha512 shadow' in /etc/pam.d/system-auth-ac]")

    notify { 'logmsg_pam_encrypt_pwd':
      withpath => false,
      message  => "*** DoD Hardening *** V-71919 vulnerability fix applied. \
[Details: Set 'password sufficient pam_unix.so sha512 shadow' in /etc/pam.d/system-auth-ac]",
      loglevel => warning,
    }

  }


}
