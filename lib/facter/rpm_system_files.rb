# rpm_system_files.rb
# V-71849

Facter.add('rpm_system_files') do
  setcode do
    Facter::Core::Execution.exec("rpm -Va | grep -o \'/.*$\'")
  end
end
