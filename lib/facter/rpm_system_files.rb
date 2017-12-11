# rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts".

Facter.add('rpm_system_files') do
  setcode do
    Facter::Core::Execution.exec("rpm -Va | grep -o \'/.*$\'")
    # .split("\n")
  end
end
