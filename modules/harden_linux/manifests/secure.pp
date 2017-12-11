#
class harden_linux::secure {

  # Vulnerability ID | Rule Name:

  # V-71849 | SRG-OS-000257-GPOS-00098
  Array rpm_files = $facts['rpm_system_files']
  String rpm_package = ''

  $rpm_files.each |String $rpm_filename| {

  # Run the following command to determine which package owns the file:
  exec { 'rpm_qf':
    command => "rpm -qf ${rpm_filename}",
    return  => $rpm_package
  }

  if ($rpm_package != '') {

    # Set file permissions per rpm package specs...
    exec { 'rpm_set_perms':
      command => "rpm --setperms ${rpm_package}"
    }

    # Set file owner per rpm package specs...
    exec { 'rpm_set_owner':
      command => "rpm --setugids ${rpm_package}"
    }

  }

}
