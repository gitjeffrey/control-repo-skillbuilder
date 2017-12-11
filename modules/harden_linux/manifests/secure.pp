#
class harden_linux::secure {

  # Vulnerability ID | Rule Name:
  # V-71849 | SRG-OS-000257-GPOS-00098
  $rpm_files = $facts['rpm_system_files']

  $harden_linux::rpm_files.each |Integer $rpm_file_index, String $rpm_filename| {

    $rpm_package = ''

    # Run the following command to determine which package owns the file:
    exec { 'v71849_0':
      command => "rpm -qf ${rpm_filename}",
      return  => $rpm_package,
    }

    notify { "rpm_filename=${rpm_filename}, rpm_package=${rpm_package}": }

    # Set file permissions and owner per rpm package spec...
    if ($rpm_package != '') {

      exec { 'v71849_1':
        command => "rpm --setperms ${rpm_package}",
      }

      exec { 'v71849_2':
        command => "rpm --setugids ${rpm_package}",
      }

    }

  }

}
