# dod_pass_reuse_generations.rb
# V-71933
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

# password sufficient pam_unix.so use_authtok sha512 shadow remember=5

Facter.add('dod_pass_reuse_generations') do
  confine :kernel => 'Linux'
  retval = Facter::Core::Execution.exec("egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/system-auth-ac | egrep -o 'remember[\s]*=[\s]*.' | awk -F= '{print $2}'").to_i
  setcode do
    if retval!=nil
      retval
    else
      "missing"
    end
  end
end
