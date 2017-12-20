# dod_rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p rpm_system_files"

Facter.add('dod_yum_installed_screen_package') do
  confine :kernel => 'Linux'
  found_package = false
  setcode do
    # Alternate command line statement:
    # rpm -qa | grep screen
    package_list = Facter::Core::Execution.exec("yum list installed | grep screen").split("\n")
    package_list.each do |package_name|
      if package_name[0...7]=="screen-"
        found_package = true
      end
    end
    found_package
  end
end
