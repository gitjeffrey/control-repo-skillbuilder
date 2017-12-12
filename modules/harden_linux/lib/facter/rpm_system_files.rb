# rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p rpm_system_files"

Facter.add('rpm_system_files') do

  confine :kernel => 'Linux'

  setcode do

    rpm_hash = {}
    rpm_array = []
    rpm_array = Facter::Core::Execution.exec("rpm -Va | grep \'^.M\' | grep -o \'/.*$\'").split("\n")

    rpm_array.each do |rpm_filename|
      rpm_hash[rpm_filename] = Facter::Core::Execution.exec("rpm -qf #{rpm_filename}")
    end

    rpm_hash

  end

end
