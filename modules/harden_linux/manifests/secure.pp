#
class harden_linux::secure {

  # Vulnerability ID | Rule Name:
  # V-71849 | SRG-OS-000257-GPOS-00098
  $rpm_files = $facts['rpm_system_files']

  notice("rpm_files=${harden_linux::secure::rpm_files}")

  $harden_linux::secure::rpm_files.each |String $rpm_filename, String $rpm_package| {

    notice("rpm_filename=${rpm_filename}, rpm_packagename=${rpm_package}")

    # Ask rpm package to reset file permissions and owner to match rpm spec...
    if ($rpm_package != '') {

      exec { "rpm --setperms ${rpm_package}":
        path => '/usr/bin'
      }

      exec { "rpm --setugids ${rpm_package}":
        path => '/usr/bin'
      }

    }

  }

}
