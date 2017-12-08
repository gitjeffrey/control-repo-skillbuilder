# rpm_system_files.rb
# V-71849
# To see fact, run...
# puppet facts rpm_system_files

Facter.add('rpm_system_files') do
  setcode do
    filelist = Facter::Core::Execution.exec("rpm -Va | grep -o \'/.*$\'")
    filelist = filelist.split('\n')
    filelist
  end
end
