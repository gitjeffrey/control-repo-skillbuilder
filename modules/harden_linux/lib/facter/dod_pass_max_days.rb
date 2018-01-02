# dod_pass_max_days.rb
# V-71931
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

Facter.add('dod_pass_max_days') do
  confine :kernel => 'Linux'
  setcode do
    retval = -1
    retval = Facter::Core::Execution.exec("grep '^PASS_MAX_DAYS' /etc/login.defs | awk -F \"\\t\" '{print $2}'")
  end
end
