# dod_pass_min_length.rb
# V-71935
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

# password sufficient pam_unix.so use_authtok sha512 shadow remember=5

Facter.add('dod_pass_min_length') do
  confine :kernel => 'Linux'
  retval = Facter::Core::Execution.exec("egrep -o '^\s*minlen\s*=\s*[0-9]+' /etc/security/pwquality.conf | awk -F= '{print $2}'").to_i
  setcode do
    if retval!=nil
      retval
    else
      "missing"
    end
  end
end
