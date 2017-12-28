# dod_userlist_min_pwd_lifetime.rb
# V-71927
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

Facter.add('dod_userlist_min_pwd_lifetime') do
  confine :kernel => 'Linux'
  setcode do
    user_array = []
    # awk -F: '$4 < 1 {print $1}' /etc/shadow
    user_array = Facter::Core::Execution.exec("awk -F: '{if ($4<1 && $2!=\"*\" && $2!=\"!!\" && $2!=\"!\") print $1}' /etc/shadow").split("\n")
    user_array
  end
end
