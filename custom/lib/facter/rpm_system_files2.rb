# WRONG DIRECTORY
# try "custom/lib/facter"?

# rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p rpm_system_files"

Facter.add('rpm_system_files2') do
  setcode do
    Facter::Core::Execution.exec("rpm -Va | grep \'^.M\' | grep -o \'/.*$\'").split("\n")
  end
end
