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
      mode    => '0644',
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
    mode    => '0644',
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
    mode    => '0644',
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

  # Research other options like nullok? No, problem means no password.  This was found in default conf...
  # password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok

  file_line { '/etc/pam.d/system-auth-ac_encrypt_pwd':
      ensure   => present,
      replace  => true,
      multiple => true,
      path     => '/etc/pam.d/system-auth-ac',
      match    => '^(?i)password\s+sufficient\s+pam_unix\.so',
      line     => 'password sufficient pam_unix.so sha512 shadow',
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



  # V-71921, V-71925, V-71929

  file_line { '/etc/login.defs_encrypt_method':
      ensure   => present,
      replace  => true,
      multiple => true,
      path     => '/etc/login.defs',
      match    => '^(?i)ENCRYPT_METHOD\s+',
      line     => 'ENCRYPT_METHOD SHA512',
  }

  file_line { '/etc/login.defs_passmindays':
      ensure   => present,
      replace  => true,
      multiple => true,
      path     => '/etc/login.defs',
      match    => '^(?i)PASS_MIN_DAYS\s+',
      line     => 'PASS_MIN_DAYS 1',
  }

  if $facts['dod_pass_max_days'] > 60 {
    file_line { '/etc/login.defs_passmaxdays':
        ensure   => present,
        replace  => true,
        multiple => true,
        path     => '/etc/login.defs',
        match    => '^(?i)PASS_MAX_DAYS\s+',
        line     => 'PASS_MAX_DAYS 60',
    }
  }

  if $::harden_linux::secure_system::logging {

    warning("${facts['fqdn']}: *** DoD Hardening *** V-71921, V-71925 & V-71929 vulnerability fixes applied. \
[Details: Set 'ENCRYPT_METHOD SHA512', 'PASS_MIN_DAYS' & 'PASS_MAX_DAYS'  in /etc/login.defs]")

    notify { 'logmsg_login_defs_encrypt_method':
      withpath => false,
      message  => "*** DoD Hardening *** V-71921, V-71925 & V-71929 vulnerability fixes applied. \
[Details: Set 'ENCRYPT_METHOD SHA512', 'PASS_MIN_DAYS' & 'PASS_MAX_DAYS' in /etc/login.defs]",
      loglevel => warning,
    }

  }



  # V-71923

  file_line { '/etc/libuser.conf_crypt_style':
      ensure   => present,
      replace  => true,
      multiple => true,
      path     => '/etc/libuser.conf',
      match    => '^(?i)crypt_style\s+=\s+',
      line     => 'crypt_style = sha512',
  }

  if $::harden_linux::secure_system::logging {

    warning("${facts['fqdn']}: *** DoD Hardening *** V-71923 vulnerability fix applied. \
[Details: Set 'crypt_style = sha512' in /etc/libuser.conf]")

    notify { 'logmsg_login_defs_crypt_style':
      withpath => false,
      message  => "*** DoD Hardening *** V-71923 vulnerability fix applied. \
[Details: Set 'crypt_style = sha512' in /etc/libuser.conf]",
      loglevel => warning,
    }

  }



  # V-71927

  # /etc/shadow file info:
  # As with the passwd file, each field in the shadow file is also separated with ":" colon characters, and are as follows:
  # 1. Username, up to 8 characters. Case-sensitive, usually all lowercase. A direct match to the username in the /etc/passwd file.
  # 2. Password, 13 character encrypted. A blank entry (eg. ::) indicates a password is not required to log in (usually a bad idea), and a ``*'' entry (eg. :*:) indicates the account has been disabled.
  # 3. The number of days (since January 1, 1970) since the password was last changed.
  # 4. The number of days before password may be changed (0 indicates it may be changed at any time)
  # 5. The number of days after which password must be changed (99999 indicates user can keep his or her password unchanged for many, many years)
  # 6. The number of days to warn user of an expiring password (7 for a full week)
  # 7. The number of days after password expires that account is disabled
  # 8. The number of days since January 1, 1970 that an account has been disabled
  # 9. A reserved field for possible future use
  # Source: http://www.tldp.org/LDP/lame/LAME/linux-admin-made-easy/shadow-file-formats.html

  # Note about identifying "system users".
  # A lot of this depends on your definition of "log in" -- technically any user who exists in /etc/passwd & /etc/shadow is a "valid user" and could theoretically log in under the right set of circumstances.
  #
  # The methods you're talking about fall into the following broad categories:
  #
  # Users with "locked" accounts
  # A user whose password is set to *, !, or some other hash that will never match is "locked out" (in the Sun days the convention was often *LK*, for "Locked").
  # These users can't log in by typing a password, but they can still log using other authentication mechanisms (SSH keys, for example).
  #
  # Users with a "non-interactive" shell
  # A user whose account has a "non-interactive shell" (/bin/false, /sbin/nologin) can't log in interactively -- i.e. they can't get a shell prompt to run commands at (this also prevents SSH command execution if the user has SSH keys on the system).
  # These users may still be able to log in to do things like read/send email (via POP/IMAP & SMTP AUTH). Setting a non-interactive shell for users who should never need to use the shell (and for most "service accounts") is generally considered good practice.
  # So depending on your criteria for "able to log in" you may want to check one or both of these things.


  $userlist_pwdminlife = $facts['dod_pass_min_days_lt_1_users']

  if $userlist_pwdminlife != undef {

    $userlist_pwdminlife.each |String $username| {

      if ($username != '') {

        exec { "chage -m 1 ${username}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {

          warning("${facts['fqdn']}: *** DoD Hardening *** V-71927 vulnerability fix applied. \
[Details: set user minimum password lifetime = 1 day (or greater) username=${username}]")

          notify { "logmsg_pwd_min_life_${username}":
            withpath => false,
            message  => "*** DoD Hardening *** V-71927 vulnerability fix applied. \
[Details: set user minimum password lifetime = 1 day (or greater) username=${username}]",
            loglevel => warning,
          }

        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71927 vulnerability fix applied. \
[Details: no users violate minimum password lifetime.]")

      notify { 'logmsg_pwd_min_life_no_users':
        withpath => false,
        message  => '*** DoD Hardening *** V-71927 vulnerability fix applied. [Details: no users violate minimum password lifetime.]',
        loglevel => warning,
      }

    }

  }



  # V-79931

  $userlist_pwdmaxlife = $facts['dod_pass_max_days_gt_60_users']

  if $userlist_pwdmaxlife != undef {

    $userlist_pwdmaxlife.each |String $username| {

      if ($username != '') {

        exec { "chage -M 60 ${username}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {

          warning("${facts['fqdn']}: *** DoD Hardening *** V-71931 vulnerability fix applied. \
[Details: set user maximum password lifetime to 60 days (or greater) username=${username}]")

          notify { "logmsg_pwd_max_life_${username}":
            withpath => false,
            message  => "*** DoD Hardening *** V-71931 vulnerability fix applied. \
[Details: set user maximum password lifetime to 60 days (or greater) username=${username}]",
            loglevel => warning,
          }

        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {

      warning("${facts['fqdn']}: *** DoD Hardening *** V-71931 vulnerability fix applied. \
[Details: no users violate the maximum password lifetime.]")

      notify { 'logmsg_pwd_max_life_no_users':
        withpath => false,
        message  => '*** DoD Hardening *** V-71931 vulnerability fix applied. [Details: no users violate the maximum password lifetime.]',
        loglevel => warning,
      }

    }

  }



  # V-71933
  # password sufficient pam_unix.so use_authtok sha512 shadow remember=5

  $remember = $facts['dod_pass_reuse_generations']

  if $remember != '' and $remember < 5 {

    file_line { '/etc/pam.d/system-auth-ac_remember':
        ensure   => present,
        replace  => true,
        multiple => true,
        path     => '/etc/pam.d/system-auth-ac',
        match    => '^(?i)password\s+sufficient\s+pam_unix.so\s+',
        line     => 'password\tsufficient\tpam_unix.so use_authtok sha512 shadow remember=5',
    }

      if $::harden_linux::secure_system::logging {

        warning("${facts['fqdn']}: *** DoD Hardening *** V-71933 vulnerability fix applied. \
[Details: Set password reuse restrictions, adding 'remember=5' in /etc/pamd.d/system-auth-ac]")

        notify { 'logmsg_system_auth_ac_remember':
          withpath => false,
          message  => "*** DoD Hardening *** V-71933 vulnerability fix applied. \
[Details: Set password reuse restrictions, adding 'remember=5' in /etc/pamd.d/system-auth-ac]",
          loglevel => warning,
        }

      }

    }



    # V-71935
    # password sufficient pam_unix.so use_authtok sha512 shadow remember=5

    $pass_min_length = $facts['dod_pass_min_length']

    if $pass_min_length != '' and $pass_min_length < 15 {

      file_line { '/etc/security/pwquality.conf_minlen':
          ensure   => present,
          replace  => true,
          multiple => true,
          path     => '/etc/security/pwquality.conf',
          match    => '^(?i)\s*minlen\s*=\s*[0-9]+',
          line     => 'minlen = 15',
      }

        if $::harden_linux::secure_system::logging {

          warning("${facts['fqdn']}: *** DoD Hardening *** V-71935 vulnerability fix applied. \
  [Details: Set password minimum password length, 'minlen = 5' in /etc/security/pwquality.conf]")

          notify { 'logmsg_system_auth_ac_remember':
            withpath => false,
            message  => "*** DoD Hardening *** V-71935 vulnerability fix applied. \
  [Details: Set password minimum password length, 'minlen = 5' in /etc/security/pwquality.conf]",
            loglevel => warning,
          }

        }

      }



} # class
