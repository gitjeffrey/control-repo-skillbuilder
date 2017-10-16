Facter.add('gitver') do
  setcode 'git --version'
end
