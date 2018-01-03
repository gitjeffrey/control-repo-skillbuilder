# dod_userlist_min_pwd_lifetime.rb
# V-71927
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

Facter.add('dod_userlist_min_pwd_lifetime') do
  confine :kernel => 'Linux'
  setcode do
    user_array = []
    user_array = Facter::Core::Execution.exec("awk -F: '{if ($4<1 && $2!=\"*\" && $2!=\"!!\" && $2!=\"!\") print $1}' /etc/shadow").to_s.strip.split("\n")
    puts "user_array.to_s=" + user_array.to_s
    #if !user_array.empty?
    #  user_array = []
    #else
    #  user_array = user_string
    #end
    user_array
  end
end
