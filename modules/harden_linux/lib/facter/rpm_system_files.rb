# rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p rpm_system_files"

Facter.add('rpm_system_files') do
  confine :kernel => 'Linux'
  setcode do
    Facter::Core::Execution.exec("rpm -Va | grep \'^.M\' | grep -o \'/.*$\'").split("\n")
  end
end
