# rpm_system_files.rb
# V-71849
# To see a custom fact, run "puppet facts".

Facter.add('rpm_system_files') do
  setcode do
    String return_fact = "empty"
    return_fact = Facter::Core::Execution.exec("rpm -Va | grep -o \'/.*$\'")
    Array return_fact_array = return_fact.split("\n")
    return_fact_array
  end
end
