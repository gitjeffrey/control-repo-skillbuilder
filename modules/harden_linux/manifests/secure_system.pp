# ::harden_linux::secure
# Harden node to Department of Defense STIG standards.

class harden_linux::secure_system {

  # Vulnerability ID | Rule Name:

  $rpm_files = $facts['rpm_system_files']

  $harden_linux::secure::rpm_files.each |String $rpm_filename, String $rpm_package| {

    # Ask rpm package to reset file permissions and owner to match rpm spec...
    if ($rpm_package != '') {

      # V-71849 | SRG-OS-000257-GPOS-00098
      exec { "rpm --setperms ${rpm_package}":
        path => ['/usr/bin', '/usr/sbin']
      }

      # V-71849 | SRG-OS-000257-GPOS-00098
      exec { "rpm --setugids ${rpm_package}":
        path => ['/usr/bin', '/usr/sbin']
      }

      notice("DoD STIG: Vulnerability V-71849 completed.  Details: rpm_filename=${rpm_filename}, rpm_packagename=${rpm_package}")

      # V-71855 | SRG-OS-000480-GPOS-00227
      exec { "rpm -Uvh ${rpm_package}":
        path => ['/usr/bin', '/usr/sbin']
      }

      notice("DoD STIG: Vulnerability V-71855 completed.  Details: rpm_filename=${rpm_filename}, rpm_packagename=${rpm_package}")

    }

  }

  # V-71859 | SRG-OS-000023-GPOS-00006
  # Source: https://help.gnome.org/admin/system-admin-guide/stable/login-banner.html.en
  if ($facts['gnome_version_file_exists']) {
    file { '/etc/dconf/profile/gdm':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults",
    }

    file { '/etc/dconf/db/local.d/01-banner-message':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "[org/gnome/login-screen]\nbanner-message-enable=true\nbanner-message-text=''",
    }

    exec { 'dconf update':
      path => ['/usr/bin', '/usr/sbin']
    }

    notice("DoD STIG: Vulnerability V-71859 completed.  Details: gnome_version_file_exists=${facts}['gnome_version_file_exists']")

  }

  # Check to see if the operating system displays a banner at the logon screen
  # with the following command:

  grep banner-message-enable /etc/dconf/db/local.d/*
  banner-message-enable=true

  # If 'banner-message-enable' is set to false or is missing, this is a finding.
  # Configure the operating system to display the Standard Mandatory
  # DoD Notice and Consent Banner before granting access to the system.

  # Note: If the system does not have GNOME installed,
  # this requirement is Not Applicable.

  touch /etc/dconf/db/local.d/01-banner-message

  # Add the following line to the [org/gnome/login-screen] section of the "/etc/dconf/db/local.d/01-banner-message":

  [org/gnome/login-screen]
  banner-message-enable=true
  banner-message-text='Type the banner message here.'





}

# "You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.
#By using this IS (which includes any device attached to this IS), you consent to the following conditions:
#-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
#-At any time, the USG may inspect and seize data stored on this IS.
#-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
#-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
#-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details."