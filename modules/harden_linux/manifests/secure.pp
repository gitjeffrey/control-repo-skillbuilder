#
class harden_linux::secure {

  # Vulnerability ID | Rule Name:
  # V-71849 | SRG-OS-000257-GPOS-00098
  Array harden_linux::rpm_files = $facts['rpm_system_files']

  $harden_linux::rpm_files.each |String $rpm_filename| {

    String harden_linux::rpm_package = ''

    # Run the following command to determine which package owns the file:
    exec { 'v71849_0':
      command => "rpm -qf ${rpm_filename}",
      return  => $harden_linux::rpm_package,
    }

    # Set file permissions and owner per rpm package spec...
    if ($harden_linux::rpm_package != '') {

      exec { 'v71849_1':
        command => "rpm --setperms ${harden_linux::rpm_package}",
      }

      exec { 'v71849_2':
        command => "rpm --setugids ${harden_linux::rpm_package}",
      }

    }

  }

}
