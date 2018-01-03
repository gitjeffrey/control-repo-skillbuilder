# dod_pass_min_days_lt_1_users.rb
# V-71927
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

Facter.add('dod_pass_min_days_lt_1_users') do
  confine :kernel => 'Linux'
  user_array = []
  user_array = Facter::Core::Execution.exec("awk -F: '{if ($4<1 && $2!=\"*\" && $2!=\"!!\" && $2!=\"!\") print $1}' /etc/shadow").to_s.strip.split("\n")
  # puts "user_array.to_s=" + user_array.to_s
  setcode do
    user_array
  end
end
