# dod_rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"
# Alternative command, rpm instead of yum:
# rpm -qa | grep screen

# Note:
# To check for screen package, decided to check for
# the term "screen." in the beginning, based on running the command:
#
# [root@puppet-agent-01 ~]# yum list installed | grep screen
# gnome-screenshot.x86_64                3.14.0-3.el7                    @anaconda
# screen.x86_64                          4.1.0-0.23.20120314git3c2946.el7_2
# [root@puppet-agent-01 ~]#

Facter.add('dod_yum_installed_screen_package') do
  confine :kernel => 'Linux'
  found_package = false
  setcode do
    package_list = Facter::Core::Execution.exec("yum list installed | grep screen").split("\n")
    package_list.each do |package_name|
      if package_name[0...7]=="screen."
        found_package = true
      end
    end
    found_package
  end
end
