# dod_pass_max_days_gt_60_users.rb
# V-71931
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

# NOTES:
# 
# '!' and '!!' mean essentially the same thing,
# but different tools use one or the other,
# passwd -l for instance, uses a pair of exclamation points.
# usermod -L on the other hand only uses one.
#
# Usually, accounts with '*' never had a password
# (as in, have always been disabled for login).
# This is different to an account with no password hash entry at all,
# in which case no password is needed (and often won't even be prompted for)
# which is nearly always BAD!.
#
# If it's an invalid hash (which all of '*', '!', and '!!' are) it effectively
# locks the account and prevents logins to that account.
# Often this is furthered by setting the account's shell to something like
# /bin/false or /sbin/nologin in the /etc/passwd file
#
# You'll often find that if a user's account is locked after previously having
# a valid password set, that password hash has exclamation marks prefixed to it,
# this is so when the account is unlocked the password resumes working again.
#
# Source:
# https://superuser.com/questions/623881/what-means-and-at-second-field-of-etc-shadow


Facter.add('dod_pass_max_days_gt_60_users') do
  confine :kernel => 'Linux'
  user_array = []
  user_array = Facter::Core::Execution.exec("awk -F: '{if ($5>60 && $2!=\"*\" && $2!=\"!!\" && $2!=\"!\") print $1}' /etc/shadow").to_s.strip.split("\n")
  # puts "user_array.to_s=" + user_array.to_s
  setcode do
    user_array
  end
end
