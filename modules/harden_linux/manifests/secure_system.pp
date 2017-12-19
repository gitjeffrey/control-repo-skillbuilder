# ::harden_linux::secure
# Harden node to Department of Defense STIG standards.
# Vulnerability ID:


class harden_linux::secure_system {

  $logging = true

  # V-71849
  $rpm_system_files = $facts['rpm_system_files']

  if $rpm_system_files != undef {

    $rpm_system_files.each |String $rpm_filename, String $rpm_package| {

      # Ask rpm package to reset file permissions and owner to match rpm spec...
      if ($rpm_package != '') {

        exec { "rpm --setperms ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        exec { "rpm --setugids ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {
          notice("DoD STIG: vulnerability V-71849 fix applied (details: rpm_filename=${rpm_filename}, rpm_packagename=${rpm_package}).")
        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {
      notice('DoD STIG: vulnerability V-71849 addressed (details: no files to process).')
    }

  }




  # V-71855
  $rpm_files_check_hash = $facts['rpm_files_check_hash']

  if $rpm_files_check_hash != undef {

    $rpm_files_check_hash.each |String $rpm_filename, String $rpm_package| {

      if ($rpm_package != '') {

        # Ask rpm to check the cryptographic hash of system files it installed.
        exec { "rpm -Uvh ${rpm_package}":
          path => ['/usr/bin', '/usr/sbin'],
        }

        if $::harden_linux::secure_system::logging {
          notice("DoD STIG: vulnerability V-71855 fix applied (details: rpm_filename=${rpm_filename}, rpm_packagename=${rpm_package}).")
        }

      }

    }

  } else {

    if $::harden_linux::secure_system::logging {
      notice('DoD STIG: vulnerability V-71855 addressed (details: no files to process).')
    }

  }




  # V-71859
  # V-71861
  # V-71891
  # Additionally, used information from GNOME help...
  # Source: https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en

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

  # Note: the \n escape character didn't work for this config file...
  if ($facts['gnome_version_file_exists']) {

    file { '/etc/dconf/profile/gdm':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0622',
      backup  => '.bak',
      content => "user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults",
    }

    file { '/etc/dconf/db/local.d/01-banner-message':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.bak',
      content => "[org/gnome/login-screen]\nbanner-message-enable=true\nbanner-message-text='${banner_msg}'",
    }

    # Added this directory location after reading GNOME help...
    # Source: https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
    file { '/etc/dconf/db/gdm.d/01-banner-message':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.bak',
      content => "[org/gnome/login-screen]\nbanner-message-enable=true\nbanner-message-text='${banner_msg}'",
    }

    # V-71891
    # Added this directory location after reading GNOME help...
    # Source: https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
    file { '/etc/dconf/db/gdm.d/00-screensaver':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.bak',
      content => 'lock-enabled=true',
    }

    file { '/etc/dconf/db/local.d/00-screensaver':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      backup  => '.bak',
      content => 'lock-enabled=true',
    }

    exec { 'dconf update':
      path => ['/usr/bin', '/usr/sbin'],
    }

    if $::harden_linux::secure_system::logging {
      notice("DoD STIG: vulnerabilities V-71859, V-71861 & V-71891 fixed (details: \
gnome_version_file_exists=${facts['gnome_version_file_exists']}).")
    }

  }




    # V-71863
    file { '/etc/issue':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0622',
      backup  => '.bak',
      content => $banner_msg,
    }

    if $::harden_linux::secure_system::logging {
      notice('DoD STIG: vulnerability V-71863 fix applied (details: /etc/issue content changed).')
    }

}
