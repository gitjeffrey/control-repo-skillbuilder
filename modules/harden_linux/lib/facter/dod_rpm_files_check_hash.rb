# dod_rpm_system_files.rb
# V-71855
# To see a custom fact, run "puppet facts" or "facter -p rpm_system_files"

Facter.add('dod_rpm_files_check_hash') do
  confine :kernel => 'Linux'
  setcode do
    rpm_hash = {}
    rpm_array = []
    rpm_array = Facter::Core::Execution.exec("rpm -Va | grep '^..5.{8}(?!c)'").split("\n")
    rpm_array.each do |rpm_filename|
      rpm_hash[rpm_filename] = Facter::Core::Execution.exec("rpm -qf #{rpm_filename}")
    end
    rpm_hash
  end
end
